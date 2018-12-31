//
//  HomeViewController.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/07.
//  Copyright © 2018 GymMania. All rights reserved.
//

import YouTubePlayer
import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties
    private var selectedCategory = ""
    private let category = Category.type
    private let provider = CategoryProvider()
    // MARK: - IBOutlet
    
    @IBOutlet private var categoryCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = identifierForSegue(segue: segue)

        switch identifier {
        case .showVideo:
            guard let destination = segue.destination as? VideoViewController else {
                assertionFailure(" no video VC!")
                return
            }
            destination.categoryType = selectedCategory
        }
    }
}

extension HomeViewController {
    private func setup() {
        setupCollectionView()
    }
    private func setupCollectionView() {
        registerNib()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = provider
        provider.setupCategory(categories: category)
        categoryCollectionView.reloadData()
    }
    private func registerNib() {
        let categoryNib = UINib(nibName: CategoryCell.nibName, bundle: nil)
        categoryCollectionView.register(categoryNib, forCellWithReuseIdentifier: CategoryCell.identifier)
        let headerNib = UINib(nibName: CategoryHeader.nibName, bundle: nil)
        categoryCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeader.identifier)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else {
            return
        }
        selectedCategory = cell.typeName
        performSegue(withIdentifier: SegueIdentifier.showVideo.rawValue, sender: self)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = categoryCollectionView.frame.width * 0.9
        let height = width * 2 / 3
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

//MARK: - SegueHandler
extension HomeViewController: SegueHandler {
    enum SegueIdentifier: String {
        case showVideo
    }
}
