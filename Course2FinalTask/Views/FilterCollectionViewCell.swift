//
//  FilterCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Milandr on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    
    fileprivate lazy var filteredThumbnailView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var filterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.largeFontSize)
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public funcs
    
    public func configureCell() {
        filteredThumbnailView.backgroundColor = .orange
        
        filterNameLabel.text = "Sample text"
        filterNameLabel.sizeToFit()
    }
    
    // MARK: - ui setup
    
    fileprivate func setupUI() {
        self.addSubview(filteredThumbnailView)
        
        filteredThumbnailView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.largeImageSize).isActive = true
        filteredThumbnailView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.largeImageSize).isActive = true
        
        self.addSubview(filterNameLabel)
        
        filterNameLabel
            .bottomAnchor
            .constraint(
                equalTo: self.bottomAnchor,
                constant: SharedConsts.UIConsts.smallOffset)
            .isActive = true
    }
}
