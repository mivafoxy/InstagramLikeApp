//
//  UploadPhotoCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Milandr on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

class UploadPhotoCollectionViewCell: PhotoCollectionViewCell {
    // MARK: - delegates
    
    public var navigationDelegate: UploadPostNavigationDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInteratcion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup ui interactions
    
    fileprivate func setupInteratcion() {
        
        self.photoView.isUserInteractionEnabled = true
        
        let gestureRecognizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(toFilters(_:)))
        
        self.photoView.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - selectors
    
    @objc fileprivate func toFilters(_ sender: UITapGestureRecognizer) {
        print("Hello from toFilters!")
        
        
    }
}
