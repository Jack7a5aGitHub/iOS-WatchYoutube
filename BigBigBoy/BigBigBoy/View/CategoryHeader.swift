//
//  CategoryHeader.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/27.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class CategoryHeader: UICollectionReusableView {

    @IBOutlet private var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    static var identifier: String {
        return self.className
    }
    static var nibName: String {
        return self.className
    }
    var headerTitle: String? {
        didSet {
            guard let headerTitle = headerTitle else {
                return
            }
            headerLabel.setBoldTextFontAndColor(text: headerTitle, fontSize: 20, color: .black)
        }
    }
}
