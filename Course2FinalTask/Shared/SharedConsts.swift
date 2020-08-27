//
//  Consts.swift
//  Course2FinalTask
//
//  Created by Milandr on 26.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class SharedConsts {
    enum Assets: String {
        case profile = "profile"
        case like = "like"
        case feed = "feed"
        case bigLike = "bigLike"
    }
    
    struct UIConsts {
        
        static let littleImageSize: CGFloat = 35.0
        static let smallImageSize: CGFloat = 44.0
        static let middleImageSize: CGFloat = 70.0
        
        static let middleFontSize: CGFloat = 14.0
        static let largeFontSize: CGFloat = 17.0
        
        static let littleOffset: CGFloat = 1.0
        static let smallOffset: CGFloat = 8.0
        static let middleOffset: CGFloat = 15.0
    }
}
