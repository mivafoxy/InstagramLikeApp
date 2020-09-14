//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 26.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate lazy var spinnerView: SpinnerViewController = {
        let viewController = SpinnerViewController()
        return viewController
    }()
    
    fileprivate let profileQueue = DispatchQueue(label: "controller.profile.queue")
    
    fileprivate let reuseId = "ProfileCell"
    fileprivate let headerId = "ProfileHeader"

    fileprivate var currentUserView: Bool = true
    fileprivate var userModel: UserModel?
    
    // MARK: - public
    
    public func setUserModel(with user: User) {
        currentUserView = false
        self.loadUserModel(from: user)
    }
    
    public func setUserModel(with post: Post) {
        currentUserView = false
        self.loadUserModel(from: post)
    }
    
    public func setUserModel(with model: UserModel) {
        currentUserView = false
        self.userModel = model
    }
    
    // MARK: - base
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinnerAsync()
        
        self.collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseId)
        
        self.collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId)
        
        if currentUserView {
            loadCurrentUser()
        }
        
        self.navigationItem.title = userModel?.username
    }
    
    // MARK: - Collection view
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userPosts = userModel?.userPosts else { return 0 }
        return userPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! PhotoCollectionViewCell
        
        if let userPosts = userModel?.userPosts {
            cell.configureCell(userPosts[indexPath.row])
        }
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header =
            collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: headerId,
                for: indexPath) as! ProfileHeaderCollectionReusableView
        
        if !header.isConfiguredOnce {
            if let user = self.userModel {
                if !user.isCurrentUser {
                    self.showSpinnerAsync()
                }
                
                header.configureView(user)
                header.navigationDelegate = self
                header.controllerDelegate = self
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 86)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 3.0
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - fileprivate funcs
    
    fileprivate func loadUserModel(from user: User, _ isCurrentUser: Bool = false) {
        DataProviders
            .shared
            .postsDataProvider
            .findPosts(by: user.id, queue: profileQueue) { (posts) in
                guard let userPosts = posts else {
                    Utils.showAlertAsync(
                        on: self,
                        title: SharedConsts.TextConsts.errorTitle,
                        message: SharedConsts.TextConsts.errorSmthWrong,
                        completion: { _ in self.loadUserModel(from: user) },
                        discard: { _ in self.removeSpinnerAsync() })
                    return
                }
                
                let model: UserModel
                
                if user.username == SharedConsts.ShittyConst.mainUserLogin {
                    model = UserModel(user, userPosts, true)
                } else {
                    model = UserModel(user, userPosts, isCurrentUser)
                }
                
                self.safeSetUserModel(with: model)
        }
    }
    
    fileprivate func loadUserModel(from post: Post) {
        DataProviders
            .shared
            .usersDataProvider
            .user(with: post.author, queue: profileQueue) { (user) in
                guard let loadedUser = user else {
                    Utils.showAlertAsync(
                        on: self,
                        title: SharedConsts.TextConsts.errorTitle,
                        message: SharedConsts.TextConsts.errorSmthWrong,
                        completion: { _ in self.loadUserModel(from: post) },
                        discard: { _ in self.removeSpinnerAsync() })
                    return
                }
                
                self.loadUserModel(from: loadedUser)
        }
    }
    
    fileprivate func loadCurrentUser() {
        DataProviders
            .shared
            .usersDataProvider
            .currentUser(queue: profileQueue) { (user) in
                guard let loadedUser = user else {
                    Utils.showAlertAsync(
                        on: self,
                        title: SharedConsts.TextConsts.errorTitle,
                        message: SharedConsts.TextConsts.errorSmthWrong,
                        completion: { _ in self.loadCurrentUser() },
                        discard: { _ in self.removeSpinnerAsync() })
                    return
                }
                
                self.loadUserModel(from: loadedUser, true)
        }
    }
    
    fileprivate func safeSetUserModel(with model: UserModel) {
        profileQueue.async {
            self.userModel = model
            self.removeSpinnerAsync()
        }
    }
    
    // MARK: - UIActions
    
    fileprivate func showSpinnerAsync() {
        DispatchQueue.main.async {
            self.addChild(self.spinnerView)
            self.spinnerView.view.frame = self.view.frame
            self.view.addSubview(self.spinnerView.view)
            self.spinnerView.didMove(toParent: self)
        }
    }
    
    fileprivate func removeSpinnerAsync() {
        DispatchQueue.main.async {
            self.spinnerView.willMove(toParent: nil)
            self.spinnerView.view.removeFromSuperview()
            self.spinnerView.removeFromParent()
            self.collectionView.reloadData()
        }
    }
}

extension ProfileViewController: ProfileHeaderNavigation {
    
    
    func navigateToUsersView(with users: [User], title: String) {
        print("Hello from profile controller")
        
        let usersVC =
            storyboard?.instantiateViewController(
                withIdentifier: String(describing: UsersViewController.self))
                as! UsersViewController
        
        usersVC.setUsers(with: users)
        usersVC.customTitle = title
        
        removeSpinnerAsync()
        
        self.navigationController?.pushViewController(usersVC, animated: true)
    }
    
    
}

extension ProfileViewController: UIControllerDelegate {
    func hideSpinnerAsync() {
        self.removeSpinnerAsync()
    }
    
    func showLoadSpinnerAsync() {
        self.showSpinnerAsync()
    }
    
    func showAlert(title: String, message: String) {
        Utils.showAlertAsync(
            on: self,
            title: title,
            message: message,
            completion: nil,
            discard: nil)
        
        self.removeSpinnerAsync()
    }
}
