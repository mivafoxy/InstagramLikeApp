//
//  ProfileHeaderCollectionReusableView.swift
//  Course2FinalTask
//
//  Created by Milandr on 26.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - queue
    fileprivate let profileHeaderQueue = DispatchQueue(label: "view.header.profile")
    
    // MARK: - private props
    
    fileprivate var userModel: UserModel!
    
    // MARK: - UI elements
    
    fileprivate lazy var avatarView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize)
        return label
    }()
    
    fileprivate lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize, weight: .semibold)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    fileprivate lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize, weight: .semibold)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    fileprivate lazy var followButton: UIButton = {
        let button = UIButton(frame: .zero)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let hexColor = 0x0096FF
        button.backgroundColor = .systemBlue
        
        
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font =
            .systemFont(
                ofSize: SharedConsts.UIConsts.middleFontSize + 1)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
        
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    // MARK: - delegates
    
    public var navigationDelegate: ProfileHeaderNavigation?
    public var controllerDelegate: UIControllerDelegate?
    
    // MARK: - fields
    public var isConfiguredOnce: Bool = false // collectionView called multiple times. I don't know how to avoid it.
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        self.setupInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public funcs
    
    public func configureView(_ user: UserModel) {
        
        if !user.isCurrentUser {
            self.followButton.isHidden = false
            self.checkCurrentUserFollowing(and: { isFollowing in
                DispatchQueue.main.async {
                    self.setupFollowButton(isFollowed: isFollowing)
                    self.controllerDelegate?.hideSpinnerAsync()
                }
            })
        }
        self.userModel = user
        
        self.avatarView.image =
            user.avatar ?? UIImage(named: SharedConsts.Assets.profile.rawValue)
        
        self.usernameLabel.text = user.username
        self.usernameLabel.sizeToFit()
        
        self.followersLabel.text = "Followers: \(user.followedByCount)"
        self.followersLabel.sizeToFit()
        
        self.followingLabel.text = "Following: \(user.followsCount)"
        self.followingLabel.sizeToFit()
        
        self.isConfiguredOnce = true
    }
    
    // MARK: - ui interaction setup
    
    fileprivate func setupInteraction() {
        let toFollowings =
            UITapGestureRecognizer(
                target: self,
                action: #selector(toFollowingsView(_:)))
        
        self.followersLabel.addGestureRecognizer(toFollowings)
        
        let toFollowed =
            UITapGestureRecognizer(
                target: self,
                action: #selector(toFollowedView(_:)))
        
        self.followingLabel.addGestureRecognizer(toFollowed)
        
        followButton.addTarget(self, action: #selector(followUser(_:)), for: .touchDown)
        followButton.addTarget(self, action: #selector(animateUp(sender:)), for: .touchUpInside)
    }
    
    // MARK: - selectors
    
    @objc fileprivate func toFollowingsView(_ sender: UITapGestureRecognizer) {
        print("Going to show you followings")
        
        self.loadFollowingUsers() { (users) in
            if let loadedUsers = users {
                DispatchQueue.main.async {
                    self.navigationDelegate?.navigateToUsersView(with: loadedUsers, title: "Following")
                }
            } else {
                self.controllerDelegate?.showAlert(
                    title: SharedConsts.TextConsts.errorTitle,
                    message: SharedConsts.TextConsts.errorSmthWrong)
            }
            
        }
    }
    
    @objc fileprivate func toFollowedView(_ sender: UITapGestureRecognizer) {
        print("Going to show you followed")
        
        self.loadFollowedUsers()
        
    }
    
    @objc fileprivate func followUser(_ sender: UIButton) {
        print("Hello from follow!")
        
        self.controllerDelegate?.showLoadSpinnerAsync()
        
        let userId = User.Identifier.init(rawValue: userModel.id)
        
        self.checkCurrentUserFollowing() { (following) in
            if following {
                self.unfollowUser(by: userId)
            } else {
                self.followUser(by: userId)
            }
            
            self.controllerDelegate?.hideSpinnerAsync()
        }
        
        animateDown(sender: sender)
    }
    
    fileprivate func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.70, y: 0.70))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 6,
                       options: [.curveEaseOut],
                       animations: {
                        button.transform = transform
        }, completion: nil)
    }
    
    // MARK: - fileprivate functions
    
    fileprivate func loadFollowingUsers(_ completion: @escaping ([User]?) -> (Void)) {
        
        guard let user = self.userModel else {
            print("Where is current userModel?")
            return
        }
        
        let userId = User.Identifier.init(rawValue: user.id)
        
        DataProviders
            .shared
            .usersDataProvider
            .usersFollowingUser(
                with: userId,
                queue: profileHeaderQueue,
                handler: completion)
    }
    
    fileprivate func loadFollowedUsers() {
        guard let user = self.userModel else {
            print("Where is current userModel?")
            return
        }
        
        let userId = User.Identifier.init(rawValue: user.id)
        
        self.controllerDelegate?.showLoadSpinnerAsync()
        
        DataProviders
            .shared
            .usersDataProvider
            .usersFollowedByUser(with: userId, queue: profileHeaderQueue) { (users) in
                if let loadedUsers = users {
                    DispatchQueue.main.async {
                        self.navigationDelegate?.navigateToUsersView(with: loadedUsers, title: "Followed")
                    }
                } else {
                    self.controllerDelegate?
                        .showAlert(
                            title: SharedConsts.TextConsts.errorTitle,
                            message: SharedConsts.TextConsts.errorSmthWrong)
                }
        }
    }
    
    fileprivate func followUser(by userId: User.Identifier) {
        DataProviders
            .shared
            .usersDataProvider
            .follow(userId, queue: profileHeaderQueue) { (user) in
                if let loadedUser = user {
                    DispatchQueue.main.async {
                        self.setupFollowButton(isFollowed: true)
                        self.configureView(
                            UserModel(
                                loadedUser,
                                self.userModel.userPosts,
                                false))
                    }
                } else {
                    self.controllerDelegate?.showAlert(
                        title: SharedConsts.TextConsts.errorTitle,
                        message: SharedConsts.TextConsts.errorSmthWrong)
                }
        }
    }
    
    fileprivate func unfollowUser(by userId: User.Identifier) {
        DataProviders
            .shared
            .usersDataProvider
            .unfollow(userId, queue: profileHeaderQueue) { (user) in
                if let loadedUser = user {
                    DispatchQueue.main.async {
                        self.setupFollowButton(isFollowed: false)
                        self.configureView(
                            UserModel(
                                loadedUser,
                                self.userModel.userPosts,
                                false))
                    }
                } else {
                    self.controllerDelegate?
                        .showAlert(
                            title: SharedConsts.TextConsts.errorTitle,
                            message: SharedConsts.TextConsts.errorSmthWrong)
                }
        }
    }
    
    fileprivate func checkCurrentUserFollowing(and completeWith: @escaping (Bool) -> (Void)) {
        DataProviders
            .shared
            .usersDataProvider
            .currentUser(queue: profileHeaderQueue) { (currentUser) in
                if let loadedCurrentUser = currentUser {
                    self.loadFollowingUsers() { (users) in
                        if let loadedUsers = users {
                            completeWith(
                                loadedUsers.contains(
                                    where: { loadedUser in
                                        loadedUser.id == loadedCurrentUser.id }))
                        } else {
                            self.controllerDelegate?
                                .showAlert(
                                    title: SharedConsts.TextConsts.errorTitle,
                                    message: SharedConsts.TextConsts.errorSmthWrong)
                        }
                    }
                }
        }
    }
    
    // MARK: - UI setup
    
    fileprivate func setupView() {
        
        self.addSubview(avatarView)
        
        avatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        avatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.middleImageSize).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.middleImageSize).isActive = true
        avatarView.layer.cornerRadius = SharedConsts.UIConsts.middleImageSize / 2.0
        
        self.addSubview(usernameLabel)
        
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        
        self.addSubview(followersLabel)
        
        followersLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1*SharedConsts.UIConsts.smallOffset).isActive = true
        followersLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        
        self.addSubview(followingLabel)
        
        followingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1*SharedConsts.UIConsts.smallOffset).isActive = true
        followingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1*SharedConsts.UIConsts.middleOffset).isActive = true
        
        self.addSubview(followButton)
        
        followButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1*SharedConsts.UIConsts.middleOffset).isActive = true
        followButton.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        followButton.isHidden = true
    }
    
    fileprivate func setupFollowButton(isFollowed: Bool) {
        if isFollowed {
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
        }
    }
    
}
