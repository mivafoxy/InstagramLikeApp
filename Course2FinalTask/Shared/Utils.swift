//
//  Utils.swift
//  Course2FinalTask
//
//  Created by Milandr on 12.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    public static func showAlertAsync(
        on viewController: UIViewController,
        title: String,
        message: String,
        completion: ((UIAlertAction) -> (Void))?,
        discard: ((UIAlertAction) -> (Void))?) {
        
        DispatchQueue.main.async {
            let alert =
                UIAlertController(
                    title: title,
                    message: message,
                    preferredStyle: .alert)
            
            if let ok = completion, let no = discard {
                alert.addAction(
                UIAlertAction(
                    title: SharedConsts.TextConsts.goBack,
                    style: .default,
                    handler: no))
                
                alert.addAction(
                    UIAlertAction(
                        title: SharedConsts.TextConsts.retry,
                        style: .default,
                        handler: ok))
            } else {
                alert.addAction(
                    UIAlertAction(
                        title: SharedConsts.TextConsts.goBack,
                        style: .default,
                        handler: nil))
            }
            
            viewController.present(alert, animated: true)
        }
    }
}
