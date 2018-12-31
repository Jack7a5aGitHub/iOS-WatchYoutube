//
//  UIActivityHelper.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/26.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class ActivityHelper {
    
    static func buildAct(item: String) -> UIActivityViewController {
        
        let activity = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.print
        ]
        activity.excludedActivityTypes = excludedActivityTypes
        return activity
    }
}
