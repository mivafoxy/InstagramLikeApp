//
//  ProfileTableViewCell.swift
//  Course2FinalTask
//
//  Created by Milandr on 26.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

class ProfileTableViewCell: UITableViewCell {
    
    fileprivate let photoCellId = "PhotoCell"
    fileprivate var currentUser: User?
    fileprivate var userPosts: [Post]?
    
    // MARK: - UI elements
    
    fileprivate lazy var profileIconView: UIImageView = {
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
    
    fileprivate lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var photoCollectionView: UICollectionView = {
        let photoLayout = UICollectionViewFlowLayout()
        photoLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: photoLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellId)
        return collectionView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    public func configureCell(_ user: User?) {
        guard let profile = user else { return }
        
        self.currentUser = profile
        
        self.userPosts = DataProviders.shared.postsDataProvider.findPosts(by: profile.id) ?? []
        
        self.profileIconView.image = profile.avatar ?? UIImage(named: SharedConsts.Assets.profile.rawValue)
        
        self.usernameLabel.text = profile.username
        self.usernameLabel.sizeToFit()
    }
    
    // MARK: - UI Setup
    
    fileprivate func setupView() {
        self.addSubview(profileIconView)
        
        profileIconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        profileIconView.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        profileIconView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.middleImageSize).isActive = true
        profileIconView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.middleImageSize).isActive = true
        
        profileIconView.layer.cornerRadius = SharedConsts.UIConsts.middleImageSize / 2.0
        
        self.addSubview(usernameLabel)
        
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileIconView.rightAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        
        self.addSubview(photoCollectionView)
        
        
        photoCollectionView.frame = self.bounds
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
    }
}

extension ProfileTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellId, for: indexPath) as! PhotoCollectionViewCell
            
        if let posts = self.userPosts {
            cell.configureCell(posts[indexPath.row].image)
        }
        
        return cell
    }
    
    
}
