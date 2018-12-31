//
//  Bundle+JSON.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import Foundation

public extension Bundle {
    
    /// JSONデータ読み込み
    ///
    /// - Parameter fileName: ファイル名
    /// - Returns: JSONデータ
    class func loadJson(fileName: String) -> String? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            return try? String(contentsOfFile: path)
        }
        return ""
    }
}
