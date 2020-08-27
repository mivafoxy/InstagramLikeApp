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

    fileprivate var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseId)
        
        self.collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId)
        
        let currentUser = DataProviders.shared.usersDataProvider.currentUser()
        posts = DataProviders.shared.postsDataProvider.findPosts(by: currentUser.id)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userPosts = posts else { return 0 }
        return userPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! PhotoCollectionViewCell
        
        if let userPosts = posts {
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
        
        header.configureView(DataProviders.shared.usersDataProvider.currentUser())
        
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
