//
//  PhotoCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Milandr on 26.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    
    internal lazy var photoView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = self.bounds
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(photoView)
        
        photoView.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: self.frame.size.height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(_ postImage: UIImage) {
        self.photoView.image = postImage
    }
}
