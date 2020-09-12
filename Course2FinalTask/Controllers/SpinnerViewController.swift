//
//  SpinnerViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 12.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {

    fileprivate lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        // MARK: - setup spinner
        
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
