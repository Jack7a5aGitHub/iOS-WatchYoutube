//
//  VideoCell.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/18.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit
import YouTubePlayer

final class VideoCell: UICollectionViewCell {

    @IBOutlet private var youtubeView: YouTubePlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        youtubeView.delegate = self
    }
    var type = ""
    static var identifier: String {
        return self.className
    }
    static var nibName: String {
        return self.className
    }
    var videoCode: String? {
        didSet {
            guard let videoCode = videoCode else {
                return
            }
            youtubeView.loadVideoID(videoCode)
        }
    }
}

extension VideoCell: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        // pause
        NotificationCenter.default.post(name: .videoReady, object: nil)
        
    }
}
