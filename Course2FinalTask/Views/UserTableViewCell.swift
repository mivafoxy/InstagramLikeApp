//
//  UserTableViewCell.swift
//  Course2FinalTask
//
//  Created by Milandr on 27.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class UserTableViewCell: UITableViewCell {

    // MARK: - props
    
    public var user: User!
    
    // MARK: - UI elements
    
    fileprivate lazy var profileAvatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.largeFontSize)
        label.textColor = .black
        return label
    }()
    
    // MARK: - public delegate
    
    public var navigationDelegate: UserViewCellNavigation?
    
    // MARK: - inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: public funcs
    
    public func configureCell(with user: User) {
        self.user = user
        self.imageView?.image = user.avatar ?? UIImage(named: SharedConsts.Assets.profile.rawValue)
        self.usernameLabel.text = user.username
        self.usernameLabel.sizeToFit()
    }
    
    // MARK: - setup user interaction
    
    fileprivate func setupInteraction() {
        self.isUserInteractionEnabled = true
        
        let navigationToProfile =
            UITapGestureRecognizer(
                target: self,
                action: #selector(toProfileView(_:)))
        
        self.addGestureRecognizer(navigationToProfile)
    }
    
    // MARK: - selectors
    
    @objc fileprivate func toProfileView(_ sender: UITapGestureRecognizer) {
        if let currentUser = user {
            self.isHighlighted = true
            navigationDelegate?.navigateToProfileView(with: currentUser)
        }
    }
    
    // MARK: - setup UI
    
    fileprivate func setupView() {
        self.addSubview(profileAvatarView)
        
        profileAvatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        profileAvatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        profileAvatarView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.middleImageSize).isActive = true
        profileAvatarView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.middleImageSize).isActive = true
        
        self.addSubview(usernameLabel)
        
        usernameLabel.leftAnchor.constraint(equalTo: profileAvatarView.rightAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
