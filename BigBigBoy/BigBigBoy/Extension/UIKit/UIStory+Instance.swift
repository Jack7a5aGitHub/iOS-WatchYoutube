//
//  UIStory+Instance.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/14.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    
    /// Storyboardからインスタンスを取得する
    class func viewController<T: UIViewController>(storyboardName: String,
                                                   identifier: String) -> T? {
        
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(
            withIdentifier: identifier) as? T
    }
}
