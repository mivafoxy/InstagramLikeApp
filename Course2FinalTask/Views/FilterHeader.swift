//
//  FilterHeader.swift
//  Course2FinalTask
//
//  Created by Milandr on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

class FilterHeader: UICollectionReusableView {
    
    // MARK: - UI elements
    
    fileprivate lazy var photoView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public funcs
    
    public func configureHeader(with image: UIImage) {
        self.photoView.image = image
    }
    
    // MARK: - setup UI
    
    fileprivate func setupUI() {
        self.addSubview(photoView)
        
        photoView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photoView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
