//
//  String+localize.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/27.
//  Copyright © 2018 GymMania. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
