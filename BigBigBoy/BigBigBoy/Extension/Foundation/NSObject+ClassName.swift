//
//  NSObject+ClassName.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/14.
//  Copyright © 2018 GymMania. All rights reserved.
//

import Foundation

public extension NSObject {
    
    /// クラス名を取得する
    static var className: String {
        return String(describing: self)
    }
}
