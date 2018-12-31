//
//  Category.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

struct Category {
    let type: String
    let typeImage: UIImage
    
    static let type: [Category] = {
        let hiit = Category(type: "HIIT", typeImage: #imageLiteral(resourceName: "HIIT"))
        let home = Category(type: "HomeWorkout", typeImage: #imageLiteral(resourceName: "homeworkout"))
        let dumbbell = Category(type: "Dumbbell", typeImage: #imageLiteral(resourceName: "dumbbell"))
        let bar = Category(type: "BarBell", typeImage: #imageLiteral(resourceName: "bar"))
        return [hiit, home, dumbbell, bar]
    }()
    
}
