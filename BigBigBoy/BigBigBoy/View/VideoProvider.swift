//
//  VideoProvider.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/18.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class VideoProvider: NSObject {
    var videoData = [SettingMenuAPI]()
    func setupVideo(videoList: [SettingMenuAPI]) {
        videoData = []
        self.videoData = videoList
    }
}

extension VideoProvider: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let videoCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VideoCell.identifier, for: indexPath) as? VideoCell else {
            fatalError()
        }
        videoCell.type = videoData[indexPath.row].name
        videoCell.videoCode = videoData[indexPath.row].videoCode
        return videoCell
    }
}
