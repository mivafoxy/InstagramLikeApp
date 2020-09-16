//
//  DescriptionViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 16.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    // MARK: - ui elements
    
    fileprivate lazy var filteredPhotoView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: SharedConsts.UIConsts.largeFontSize)
        label.text = "Add description"
        label.sizeToFit()
        
        return label
    }()
    
    fileprivate lazy var descriptionTextField: UITextField = {
        
        let sampleTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30.00))
        sampleTextField.translatesAutoresizingMaskIntoConstraints = false
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.borderStyle = .roundedRect
        
        return sampleTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    // MARK: - public funcs
    
    public func setupMainPhotoView(with photo: UIImage) {
        filteredPhotoView.image = photo
    }
    
    // MARK: - setup ui
    
    fileprivate func setupUI() {
        view.addSubview(filteredPhotoView)
        
        filteredPhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        filteredPhotoView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        filteredPhotoView.widthAnchor.constraint(equalToConstant: SharedConsts.UIConsts.bigImageSize).isActive = true
        filteredPhotoView.heightAnchor.constraint(equalToConstant: SharedConsts.UIConsts.bigImageSize).isActive = true
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: filteredPhotoView.bottomAnchor, constant: SharedConsts.UIConsts.largeOffset).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        
        view.addSubview(descriptionTextField)
        
        descriptionTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: SharedConsts.UIConsts.middleOffset).isActive = true
        descriptionTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -1*SharedConsts.UIConsts.middleOffset).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: SharedConsts.UIConsts.smallOffset).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: nil, action: nil)
    }
}
