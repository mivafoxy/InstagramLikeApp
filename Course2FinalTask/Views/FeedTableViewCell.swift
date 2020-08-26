//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Milandr on 18.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedTableViewCell: UITableViewCell {
    
    
    
    // MARK: - Cell model
    fileprivate var post: Post?
    
    // MARK: - View elements
    
    fileprivate lazy var postImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    fileprivate lazy var authorProfileView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var postDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize)
        return label
    }()
    
    fileprivate lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize, weight: .semibold)
        label.clipsToBounds = true
        return label
    }()
    
    fileprivate lazy var likeImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.middleFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var bigLikeView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: SharedConsts.Assets.bigLike.rawValue)
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
        self.setupViewInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    public func configureCell(_ post: Post) {
        self.post = post
        
        self.authorProfileView.image = post.authorAvatar ?? UIImage(named: SharedConsts.Assets.profile.rawValue)
        self.postImageView.image = post.image
        self.usernameLabel.text = post.authorUsername
        self.usernameLabel.sizeToFit()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        self.postDateLabel.text = dateFormatter.string(from: post.createdTime)
        self.postDateLabel.sizeToFit()
        
        self.likesLabel.text = "Likes: \(post.likedByCount)"
        self.likesLabel.sizeToFit()
        
        if post.currentUserLikesThisPost {
            self.likeImageView.tintColor = .blue
        } else {
            self.likeImageView.tintColor = .gray
        }
        
        self.descriptionLabel.text = post.description
        self.descriptionLabel.sizeToFit()
    }
    
    // MARK: - Setup view interactions
    
    fileprivate func setupViewInteraction() {
        
        // Setup post image interaction
        
        let postImageViewDoubleTapRecognizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(handlePostImageViewDoubleTap(_:)))
        
        postImageViewDoubleTapRecognizer.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(postImageViewDoubleTapRecognizer)
        
        // Setup little like image interaction
        
        let likeImageGestureTaprecognizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(handleLikeImageTap(_:)))
        
        likeImageView.addGestureRecognizer(likeImageGestureTaprecognizer)
        
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func handlePostImageViewDoubleTap(_ sender: UITapGestureRecognizer) {
        print("Double tap!")
        
        // Setup a big like scaling animation
        self.setupBigLikeIcon()
        
        let bigLikeScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        bigLikeScaleAnimation.fromValue = 0.0
        bigLikeScaleAnimation.toValue = 2.0
        
        let bigLikeFadeAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        bigLikeFadeAnimation.fromValue = 1
        bigLikeFadeAnimation.toValue = 0.0
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [ bigLikeScaleAnimation, bigLikeFadeAnimation ]
        groupAnimation.duration = 1.0
        groupAnimation.fillMode = .removed
        groupAnimation.isRemovedOnCompletion = true
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        groupAnimation.delegate = self
        
        bigLikeView.layer.add(groupAnimation, forKey: "bigLike")
        
        // Change like color, and likes count, and who liked
        
        guard let currentPost = post else { return }
        
        let hasLike = DataProviders.shared.postsDataProvider.likePost(with: currentPost.id)
        
        if hasLike {
            let newPostData =
                DataProviders.shared
                    .postsDataProvider
                    .post(
                        with: currentPost.id)
            
            guard let newPost = newPostData else { return }
            
            configureCell(newPost)
        }
    }
    
    @objc fileprivate func handleLikeImageTap(_ sender: UITapGestureRecognizer) {
        print("Like image tap!")
        
        guard let currentPost = post else { return }
        
        if currentPost.currentUserLikesThisPost {
            _ = DataProviders.shared.postsDataProvider.unlikePost(with: currentPost.id)
        } else {
            _ = DataProviders.shared.postsDataProvider.likePost(with: currentPost.id)
        }
        
        guard let newPost =
            DataProviders.shared
                .postsDataProvider
                .post(
                    with: currentPost.id) else {
                        return
        }
        
        self.configureCell(newPost)
    }
    
    // MARK: - Setup GUI
    
    fileprivate func setupView() {
        self.selectionStyle = .none
        
        self.addSubview(authorProfileView)
        
        authorProfileView.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        authorProfileView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        authorProfileView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.littleImageSize).isActive = true
        authorProfileView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.littleImageSize).isActive = true
        
        self.addSubview(descriptionLabel)
        
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: SharedConsts.UIConsts.littleOffset).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1*SharedConsts.UIConsts.middleOffset).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        
        self.addSubview(likeImageView)
        
        likeImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1*SharedConsts.UIConsts.middleOffset).isActive = true
        likeImageView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.smallImageSize).isActive = true
        likeImageView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.smallImageSize).isActive = true
        likeImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: SharedConsts.UIConsts.littleOffset).isActive = true
        likeImageView.image = UIImage(named: "like")
        
        self.addSubview(likesLabel)
        
        likesLabel.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor).isActive = true
        likesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        
        self.addSubview(postImageView)
        
        postImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: authorProfileView.bottomAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: likeImageView.topAnchor).isActive = true
        
        self.addSubview(usernameLabel)
        
        usernameLabel.leftAnchor.constraint(equalTo: authorProfileView.rightAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        
        self.addSubview(postDateLabel)
        
        postDateLabel.leftAnchor.constraint(equalTo: authorProfileView.rightAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        postDateLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: SharedConsts.UIConsts.littleOffset).isActive = true
        
        
    }
    
    fileprivate func setupBigLikeIcon() {
        self.addSubview(bigLikeView)
        
        bigLikeView.centerXAnchor.constraint(equalTo: postImageView.centerXAnchor).isActive = true
        bigLikeView.centerYAnchor.constraint(equalTo: postImageView.centerYAnchor).isActive = true
    }
}

extension FeedTableViewCell : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.bigLikeView.removeFromSuperview()
    }
}
