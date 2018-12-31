//
//  LoadJsonFileHelp.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import Foundation

struct SettingMenuAPIList: Decodable {
    let settingMenuList: [SettingMenuAPI]
}

struct SettingMenuAPI: Codable {
    var name = ""
    var videoCode = ""
}

final class LoadJsonFileHelper {
    static func fetchMenu(fileName: String) -> [SettingMenuAPI] {
        guard let jsonString = Bundle.loadJson(fileName: fileName) else {
            fatalError("Can not be read JSON")
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            fatalError("Can not convert to JSON")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let fetchResult = try? decoder.decode(SettingMenuAPIList.self, from: data) else {
            fatalError("JSON decoding failed.")
        }
        return fetchResult.settingMenuList
    }
}
