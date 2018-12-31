//
//  NoFavouriteCell.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/25.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class NoFavouriteCell: UICollectionViewCell {

    @IBOutlet private var noDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    static var identifier: String {
        return self.className
    }
    static var nibName: String {
        return self.className
    }
    var noVideo: String = "" {
        didSet {
            NotificationCenter.default.post(name: .videoReady, object: nil)
            noDataLabel.setBoldTextFontAndColor(text: noVideo, fontSize: 20, color: .black)
        }
    }
}
