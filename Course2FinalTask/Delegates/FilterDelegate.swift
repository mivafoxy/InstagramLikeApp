//
//  FilterDelegate.swift
//  Course2FinalTask
//
//  Created by Milandr on 16.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

protocol FilterDelegate {
    func imposeFilterAsync(with filterName: String, completion: ((UIImage) -> (Void))?)
}
