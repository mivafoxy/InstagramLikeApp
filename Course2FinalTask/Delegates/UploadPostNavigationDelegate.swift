//
//  UploadPostNavigationDelegate.swift
//  Course2FinalTask
//
//  Created by Milandr on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit


protocol UploadPostNavigationDelegate {
    func navigateToFilters(with photo: UIImage, and thumb: UIImage)
    func navigateToDescription(with filteredPhoto: UIImage)
}
