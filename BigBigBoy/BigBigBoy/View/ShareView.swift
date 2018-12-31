//
//  ShareView.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/25.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class ShareView: UIView {

    let imageView = UIImageView()
    var selected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func createImage() {
        self.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "share")
        imageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.centerInSuperview(size: .init(width: 20, height: 20))
        
    }
    
    private func commonInit() {
        // do stuff here
        print("share")
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        createImage()
    }
    func turnRed() {
        selected = true
        imageView.image = #imageLiteral(resourceName: "share-selected")
        self.backgroundColor = #colorLiteral(red: 1, green: 0.2315282524, blue: 0.1882175505, alpha: 1)
    }
    func backToNormal() {
        selected = false
        imageView.image = #imageLiteral(resourceName: "share")
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

}
