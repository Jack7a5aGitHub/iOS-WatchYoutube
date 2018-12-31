//
//  AlertHelper.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/26.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class AlertHelper {
    
    static func buildAlert(title: String = "",
                           message: String,
                           rightButtonTitle: String = "OK",
                           leftButtonTitle: String? = nil,
                           rightButtonAction: ((UIAlertAction) -> Void)? = nil,
                           leftButtonAction: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let positiveAction = UIAlertAction(title: rightButtonTitle, style: .default, handler: rightButtonAction)
        
        if let leftButtonTitle = leftButtonTitle {
            let negativeAction = UIAlertAction(title: leftButtonTitle, style: .default, handler: leftButtonAction)
            alert.addAction(negativeAction)
        }
        alert.addAction(positiveAction)
        return alert
    }
    
}
