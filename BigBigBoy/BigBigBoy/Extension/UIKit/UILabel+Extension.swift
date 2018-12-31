//
//  UILabel+Extension.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setBoldTextFontAndColor(text: String, fontSize size: CGFloat, color: UIColor) {
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: size)
        self.textColor = color
    }
    func setTextFontAndColor(text: String, fontSize size: CGFloat, color: UIColor) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: size)
        self.textColor = color
    }

}
