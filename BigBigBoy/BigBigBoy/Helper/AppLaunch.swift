
//
//  AppLaunch.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/26.
//  Copyright © 2018 GymMania. All rights reserved.
//


import Foundation

final class AppLaunch: NSObject {
    
    /// アプリ初回起動済みの状態を保存する
    static func completedVideoLaunch() {
        UserDefaults().set(true, forKey: .completeVideoTutorial)
    }
    /// アプリ初回起動済みの状態を保存する
    static func completedFavourLaunch() {
        UserDefaults().set(true, forKey: .completeFavourTutorial)
    }
    /// 画面初回起動かどうか判定する
    ///
    /// - Returns: true: 初回起動, false: 非初回起動
    static func isFirstTimeVideo() -> Bool {
        guard let completedVideoLaunch = UserDefaults().bool(forKey: .completeVideoTutorial) else {
            return true
        }
        return !completedVideoLaunch
    }
    
    static func isFirstTimeFavour() -> Bool {
        guard let completedFavourLaunch = UserDefaults().bool(forKey: .completeFavourTutorial) else {
            return true
        }
        return !completedFavourLaunch
    }
}
