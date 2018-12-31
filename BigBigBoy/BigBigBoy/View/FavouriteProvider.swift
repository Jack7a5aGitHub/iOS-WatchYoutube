//
//  FavouriteProvider.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/25.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

struct FavouriteVideo {
    var videoCode: String
    var typeName: String
}

final class FavouriteProvider: NSObject {
    var videoData = [FavouriteVideo]()
    func setupVideo(videoList: [FavouriteVideo]) {
        videoData = []
        self.videoData = videoList
    }
}

extension FavouriteProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videoData.isEmpty {
            return 1
        }
        return videoData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let noVideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: NoFavouriteCell.identifier, for: indexPath) as? NoFavouriteCell else {
            fatalError()
        }
        guard let videoCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VideoCell.identifier, for: indexPath) as? VideoCell else {
                fatalError()
        }
        if videoData.isEmpty {
            cell = noVideoCell
            noVideoCell.noVideo = "No Favourite Video"
        } else {
            cell = videoCell
            videoCell.type = videoData[indexPath.row].typeName
            videoCell.videoCode = videoData[indexPath.row].videoCode
        }

        return cell
    }
}

