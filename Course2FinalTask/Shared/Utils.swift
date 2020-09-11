//
//  Utils.swift
//  Course2FinalTask
//
//  Created by Milandr on 27.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

class Utils {
    static func findUsers(by ids: [User.Identifier]) -> [User] {
        var users: [User] = []
        
        for id in ids {
            if let user = DataProviders.shared.usersDataProvider.user(with: id) {
                users.append(user)
            }
        }
        
        return users
    }
}
