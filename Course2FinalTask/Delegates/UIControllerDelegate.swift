//
//  UIControllerDelegate.swift
//  Course2FinalTask
//
//  Created by Milandr on 13.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

protocol UIControllerDelegate {
    func showLoadSpinnerAsync()
    func hideSpinnerAsync()
    func showAlert(title: String, message: String)
}
