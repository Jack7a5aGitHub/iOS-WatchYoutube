//
//  FavouriteViewController.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/20.
//  Copyright © 2018 GymMania. All rights reserved.
//

import CoreData
import Instructions
import SVProgressHUD
import UIKit

final class FavouriteViewController: UIViewController {

    // MARK: - Properties
    private var selectedVideoCode = ""
    private var selectedType = ""
    private var favouriteVideo = [FavouriteVideo]()
    private let provider = FavouriteProvider()
    private var deleteView = TrashBinView()
    private var shareView = ShareView()
    private let coachMarksController = CoachMarksController()

    // MARK: - IBOutlet
    @IBOutlet private var favouriteCollection: UICollectionView!
    @IBOutlet private var tutorView: UIView!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerObserver()
        setupCollection()
        registerGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
}

extension FavouriteViewController {
    
    private func setupCollection() {
        registerNib()
        favouriteCollection.dataSource = provider
        favouriteCollection.delegate = self
    }
    
    private func registerGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleCellLongPress(recognizer:)))
        favouriteCollection.addGestureRecognizer(longPress)
    }
    @objc private func handleCellLongPress(recognizer: UILongPressGestureRecognizer) {
        
        let touchPoint = recognizer.location(in: favouriteCollection)
        guard let indexPath = favouriteCollection.indexPathForItem(at: touchPoint) else {
            return
        }
        
        switch recognizer.state {
        // need to get cell info when began the long press and shut off rest of cells
        case .began:
            deleteView = TrashBinView(frame: CGRect(x: touchPoint.x - 80,
                                                             y:  touchPoint.y - 20,
                                                             width: 50,
                                                             height: 50))
            shareView = ShareView(frame: CGRect(x: touchPoint.x - 20,
                                                y: touchPoint.y - 80,
                                                width: 50,
                                                height: 50))
            favouriteCollection.addSubview(deleteView)
            favouriteCollection.addSubview(shareView)
            guard let cell = favouriteCollection.cellForItem(at: indexPath) as? VideoCell else {
                return
            }
            guard let videoCode = cell.videoCode else {
                return
            }
            selectedVideoCode = videoCode
            selectedType = cell.type
        // pop up view
        case .changed:
            //  update pointer, change icon color
            let touchPoint = recognizer.location(in: favouriteCollection)
            let trashValidRect = CGRect(x: deleteView.frame.minX,
                                        y: deleteView.frame.minY,
                                        width: deleteView.frame.width + 15,
                                        height: deleteView.frame.height)
            let shareValidRect = CGRect(x: shareView.frame.minX,
                                        y: shareView.frame.minY,
                                        width: shareView.frame.width,
                                        height: shareView.frame.height + 15)
            if trashValidRect.contains(touchPoint) {
                deleteView.turnRed()
            } else {
                deleteView.backToNormal()
            }
            if shareValidRect.contains(touchPoint) {
                shareView.turnRed()
            } else {
                shareView.backToNormal()
            }
        case .ended:
            // off view, determine save or not
            
            for view in favouriteCollection.subviews {
                if view is ShareView || view is TrashBinView {
                    view.removeFromSuperview()
                }
            }
            if deleteView.selected {
                print("delete from my favourite", selectedType, selectedVideoCode)
                deleteData(videoCode: selectedVideoCode)
                
            } else if shareView.selected {
                print("share")
                let videoUrl = "https://www.youtube.com/watch?v=\(selectedVideoCode)"
                showActivity(item: videoUrl)
            } else {
                print("do nothing just cancel")
            }
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        default:
            break
        }
        
    }
    private func showActivity(item: String) {
        let activity = ActivityHelper.buildAct(item: item)
        present(activity, animated: false)
    }
    private func fetchData() {
        SVProgressHUD.BigBig.show()
        retrieveData()
        
    }
    private func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        favouriteVideo = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        do {
            guard let result = try managedContext.fetch(fetchResult) as? [NSManagedObject] else {
                return
            }
            for data in result {
                guard let videoCode = data.value(forKey: "videoCode") as? String,
                      let typeName = data.value(forKey: "type") as? String else {
                        return
                }
                favouriteVideo.append(FavouriteVideo(videoCode: videoCode,
                                                     typeName: typeName))
            }
            provider.setupVideo(videoList: favouriteVideo)
            favouriteCollection.reloadData()
        } catch let error as NSError {
            print("couldnt fetch \(error)")
        }
    }
    private func deleteData(videoCode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchResult.predicate = NSPredicate(format: "videoCode = %@", videoCode)
        do {
            let delete = try managedContext.fetch(fetchResult)
            guard let objectToDelete = delete[0] as? NSManagedObject else {
                print("no object to delete")
                return
            }
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
                fetchData()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    private func registerNib() {
        let videoNib = UINib(nibName: VideoCell.nibName, bundle: nil)
        let noFavourNib = UINib(nibName: NoFavouriteCell.nibName, bundle: nil)
        favouriteCollection.register(videoNib, forCellWithReuseIdentifier: VideoCell.identifier)
        favouriteCollection.register(noFavourNib, forCellWithReuseIdentifier: NoFavouriteCell.identifier)
    }
    private func registerObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(videoReady),
                                       name: .videoReady, object: nil)
    }
    @objc private func videoReady() {
        SVProgressHUD.dismiss()
        setupCoachMark()
        
    }
    private func setupCoachMark() {
        if AppLaunch.isFirstTimeFavour() && !favouriteVideo.isEmpty {
            coachMarksController.dataSource = self
            coachMarksController.delegate = self
            self.coachMarksController.start(in: .window(over: self))
        }
    }
}

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = favouriteCollection.frame.width * 0.9
        let height = width * 2 / 3
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension FavouriteViewController: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let hintText = "FAVOUR_HINT".localized()
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        return coachMarksController.helper.makeCoachMark(for: tutorView)
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    func coachMarksController(_ coachMarksController: CoachMarksController, didHide coachMark: CoachMark, at index: Int) {

        AppLaunch.completedFavourLaunch()
    }
    
    
}
