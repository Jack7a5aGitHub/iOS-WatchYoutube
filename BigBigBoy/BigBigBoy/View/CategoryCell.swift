//
//  CategoryCell.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class CategoryCell: UICollectionViewCell {

    @IBOutlet private var typeImageView: UIImageView!
    @IBOutlet private var typeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static var identifier: String {
        return self.className
    }
    
    static var nibName: String {
        return self.className
    }
    
    var typeName = ""
    var typeImage: UIImage? {
        didSet {
            guard let typeImage = typeImage else {
                return
            }
            typeImageView.image = typeImage
        }
    }
}
