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

    fileprivate let reuseId = "ProfileCell"
    fileprivate let headerId = "ProfileHeader"

    fileprivate var userModel: UserModel?
    
    // MARK: - public
    
    public func setUserModel(with user: User) {
        self.userModel = UserModel(user)
    }
    
    public func setUserModel(with post: Post) {
        self.userModel = UserModel(post)
    }
    
    public func setUserModel(with model: UserModel) {
        self.userModel = model
    }
    
    // MARK: - base
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseId)
        
        self.collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId)
        
        if let _ = userModel {
            
        } else {
            userModel = UserModel(DataProviders.shared.usersDataProvider.currentUser())
        }
        
        self.navigationItem.title = userModel?.username
    }
    
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
        
        if let user = self.userModel {
            header.configureView(user)
            header.navigationDelegate = self
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
        
        self.navigationController?.pushViewController(usersVC, animated: true)
    }
    
    
}
