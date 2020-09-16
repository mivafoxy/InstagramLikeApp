//
//  FilterCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Milandr on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - private fields
    
    fileprivate var filterName: String?
    
    // MARK: - UI elements
    
    fileprivate lazy var filteredThumbnailView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    fileprivate lazy var filterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.largeFontSize)
        return label
    }()
    
    // MARK: public delegates
    
    public var filterDelegate: FilterDelegate?
    public var navigationDelegate: UploadPostNavigationDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.setupInteractions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public funcs
    
    public func configureCell(_ thumb: UIImage, _ filterName: String) {
        
        filteredThumbnailView.image = thumb
        
        self.filterName = filterName
        filterNameLabel.text = filterName.replacingOccurrences(of: "PhotoEffect", with: "")
        filterNameLabel.sizeToFit()
    }
    
    // MARK: - selectors
    
    @objc fileprivate func callToFilterImposing(_ sender: UITapGestureRecognizer) {
        print("going to impose filter on photo!")
        
        guard let filter = filterName else { return }
        
        filterDelegate?.imposeFilterAsync(with: filter) { (image) in
            DispatchQueue.main.async {
                self.navigationDelegate?.navigateToDescription(with: image)
            }
        }
    }
    
    // MARK: - ui setup
    
    fileprivate func setupUI() {
        self.addSubview(filteredThumbnailView)
        
        filteredThumbnailView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.largeImageSize).isActive = true
        filteredThumbnailView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.largeImageSize).isActive = true
        filteredThumbnailView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        filteredThumbnailView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(filterNameLabel)
        
        filterNameLabel
            .topAnchor
            .constraint(
                equalTo: filteredThumbnailView.bottomAnchor,
                constant: SharedConsts.UIConsts.smallOffset)
            .isActive = true
        
        filterNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    fileprivate func setupInteractions() {
        let tapRecgnizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(callToFilterImposing(_:)))
        
        filteredThumbnailView.addGestureRecognizer(tapRecgnizer)
    }
}
