//
//  PopUpView.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/19.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class FavouritePopUpView: UIView {
    
    let label = UILabel()
    var selected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func createLabel() {
        self.addSubview(label)
        label.textAlignment = .center
        label.setTextFontAndColor(text: "♡", fontSize: 18, color: .black)
        label.centerInSuperview(size: .init(width: 20, height: 20))
        
    }
    
    private func commonInit() {
        // do stuff here
        print("create")
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        createLabel()
    }
    func turnRed() {
        selected = true
        self.backgroundColor = #colorLiteral(red: 1, green: 0.2315282524, blue: 0.1882175505, alpha: 1)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    func backToNormal() {
        selected = false
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
