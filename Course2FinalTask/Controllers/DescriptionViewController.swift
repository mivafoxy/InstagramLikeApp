//
//  DescriptionViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 16.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class DescriptionViewController: UIViewController {

    // MARK: - ui elements
    
    fileprivate lazy var spinnerView: SpinnerViewController = {
        let spinner = SpinnerViewController()
        return spinner
    }()
    
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
    
    // MARK: - selectors
    
    @objc fileprivate func sharePost(_ sender: Any?) {
        
        let newPostImage = filteredPhotoView.image!
        let description = descriptionTextField.text ?? ""
        
        let queue = DispatchQueue(label: "controller.description.share.post")
        
        self.showSpinnerAsync()
        
        DataProviders
            .shared
            .postsDataProvider
            .newPost(
                with: newPostImage,
                description: description,
                queue: queue) { (post) in
                    if let _ = post {
                        // TODO: go to root of navigation stack
                        print("Upload success!")
                        self.returnToRootAsync()
                    } else {
                        print("Upload error!")
                        // TODO: Show alert - go to root of navigation stack
                        Utils.showAlertAsync(
                            on: self,
                            title: SharedConsts.TextConsts.errorTitle,
                            message: SharedConsts.TextConsts.errorSmthWrong,
                            completion: { (action) in self.sharePost(sender) },
                            discard: { (action) in self.returnToRootAsync() })
                    }
                    
                    
        }
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
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(sharePost(_:)))
    }
    
    // MARK: - UIActions
    
    fileprivate func showSpinnerAsync() {
        DispatchQueue.main.async {
            self.addChild(self.spinnerView)
            self.spinnerView.view.frame = self.view.frame
            self.view.addSubview(self.spinnerView.view)
            self.spinnerView.didMove(toParent: self)
        }
    }
    
    fileprivate func removeSpinnerAsync() {
        DispatchQueue.main.async {
            self.spinnerView.willMove(toParent: nil)
            self.spinnerView.view.removeFromSuperview()
            self.spinnerView.removeFromParent()
        }
    }
    
    fileprivate func returnToRootAsync() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
