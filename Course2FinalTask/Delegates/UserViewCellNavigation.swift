//
//  UserViewCellNavigation.swift
//  Course2FinalTask
//
//  Created by Milandr on 27.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

protocol UserViewCellNavigation {
    func navigateToProfileView(with user: User)
    func showLoadSpinnerAsync()
}
