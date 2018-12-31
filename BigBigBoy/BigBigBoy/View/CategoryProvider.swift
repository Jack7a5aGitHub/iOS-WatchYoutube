//
//  CategoryProvider.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit

final class CategoryProvider: NSObject {
    var category = [Category]()
    func setupCategory(categories: [Category]) {
        self.category = []
        self.category = categories
    }
}

extension CategoryProvider: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind.isEqual(UICollectionView.elementKindSectionHeader) {
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeader.identifier, for: indexPath) as? CategoryHeader else {
                fatalError()
            }
                sectionHeader.headerTitle = category[indexPath.section].type.localized()
                return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
                fatalError("no cell")
        }
        categoryCell.typeName = category[indexPath.section].type
        categoryCell.typeImage = category[indexPath.section].typeImage
        return categoryCell
    }
}
