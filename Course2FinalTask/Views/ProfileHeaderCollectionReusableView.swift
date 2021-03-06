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
    
    // MARK: - delegates
    
    public var navigationDelegate: ProfileHeaderNavigation?
    
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
        self.userModel = user
        
        self.avatarView.image =
            user.avatar ?? UIImage(named: SharedConsts.Assets.profile.rawValue)
        
        self.usernameLabel.text = user.username
        self.usernameLabel.sizeToFit()
        
        self.followersLabel.text = "Followers: \(user.followedByCount)"
        self.followersLabel.sizeToFit()
        
        self.followingLabel.text = "Following: \(user.followsCount)"
        self.followingLabel.sizeToFit()
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
    }
    
    // MARK: - selectors
    
    @objc fileprivate func toFollowingsView(_ sender: UITapGestureRecognizer) {
        print("Going to show you followings")
        
        guard let delegate =
            self.navigationDelegate else {
                return
        }
        
        guard let user =
            self.userModel else {
                return
        }
        
        let userId = User.Identifier.init(rawValue: user.id)
        
        let users = DataProviders.shared.usersDataProvider.usersFollowingUser(with: userId)
        
        if let profiles = users {
            delegate.navigateToUsersView(with: profiles, title: "Followers")
        }
    }
    
    @objc fileprivate func toFollowedView(_ sender: UITapGestureRecognizer) {
        print("Going to show you followed")
        
        guard let delegate =
            self.navigationDelegate else {
                return
        }
        
        guard let user =
            self.userModel else {
                return
        }
        
        let userId = User.Identifier.init(rawValue: user.id)
        
        let users = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userId)
        
        if let profiles = users {
            delegate.navigateToUsersView(with: profiles, title: "Following")
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
    }
    
}
