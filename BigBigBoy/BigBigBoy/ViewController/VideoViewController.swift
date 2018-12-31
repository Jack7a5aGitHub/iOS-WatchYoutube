//
//  VideoViewController.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import CoreData
import Instructions
import SVProgressHUD
import UIKit

final class VideoViewController: UIViewController {

    // MARK: - Properties
    var categoryType = ""
    private var selectedVideoCode = ""
    private var selectedType = ""
    private var visualEffectView: UIVisualEffectView?
    private var videoList = [SettingMenuAPI]()
    private let provider = VideoProvider()
    private var favouriteView = FavouritePopUpView()
    private var shareView = ShareView()
    private let coachMarksController = CoachMarksController()

    // MARK: - IBOutlet
    @IBOutlet private var videoCollection: UICollectionView!
    @IBOutlet private var tutorView: UIView!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        self.coachMarksController.stop(immediately: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension VideoViewController {
    
    private func setup() {
        self.title = categoryType
        setupCollectionView()
        registerObserver()
        registerGesture()
        SVProgressHUD.BigBig.show()
    }
    private func setupCoachMark() {
        if AppLaunch.isFirstTimeVideo() {
            coachMarksController.dataSource = self
            coachMarksController.delegate = self
            self.coachMarksController.start(in: .window(over: self))
        }
    }
    private func registerObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(videoReady),
                                       name: .videoReady, object: nil)
    }
    private func registerGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleCellLongPress(recognizer:)))
        videoCollection.addGestureRecognizer(longPress)
    }
    private func showActivity(item: String) {
        let activity = ActivityHelper.buildAct(item: item)
        present(activity, animated: false)
    }
    @objc private func handleCellLongPress(recognizer: UILongPressGestureRecognizer) {
        let touchPoint = recognizer.location(in: videoCollection)
        guard let indexPath = videoCollection.indexPathForItem(at: touchPoint) else {
            return
        }
        switch recognizer.state {
            // need to get cell info when began the long press and shut off rest of cells
        case .began:
          
            favouriteView = FavouritePopUpView(frame: CGRect(x: touchPoint.x - 80,
                                                     y:  touchPoint.y - 20,
                                                     width: 50,
                                                     height: 50))
            shareView = ShareView(frame: CGRect(x: touchPoint.x - 20,
                                                y: touchPoint.y - 80,
                                                width: 50,
                                                height: 50))
            videoCollection.addSubview(favouriteView)
            videoCollection.addSubview(shareView)
            guard let cell = videoCollection.cellForItem(at: indexPath) as? VideoCell else {
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
            let touchPoint = recognizer.location(in: videoCollection)
            let favourValidRect = CGRect(x: favouriteView.frame.minX, y: favouriteView.frame.minY, width: favouriteView.frame.width + 15, height: favouriteView.frame.height)
            let shareValidRect = CGRect(x: shareView.frame.minX,
                                        y: shareView.frame.minY,
                                        width: shareView.frame.width,
                                        height: shareView.frame.height + 15)
            if favourValidRect.contains(touchPoint) {
                favouriteView.turnRed()
            } else {
                favouriteView.backToNormal()
            }
            if shareValidRect.contains(touchPoint) {
                shareView.turnRed()
            } else {
                shareView.backToNormal()
            }
        case .ended:
            // off view, determine save or not
      
            for view in videoCollection.subviews {
                if view is ShareView || view is FavouritePopUpView {
                    view.removeFromSuperview()
                }
            }
            if favouriteView.selected {
                print("add to my favourite", selectedType, selectedVideoCode)
                let isInList = alreadyInFavourList(videoCode: selectedVideoCode)
                isInList ? showAlert() : createData(typeName: selectedType, videoCode: selectedVideoCode)
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
    @objc private func videoReady() {
        SVProgressHUD.dismiss()
        setupCoachMark()
    }
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    private func showAlert() {
        let alert = AlertHelper.buildAlert(message: "ERROR_IN_FAVOUR".localized())
        present(alert, animated: false)
    }
    private func setupCollectionView() {
        registerNib()
        videoList = LoadJsonFileHelper.fetchMenu(fileName: categoryType)
        videoCollection.delegate = self
        videoCollection.dataSource = provider
        provider.setupVideo(videoList: videoList)
        videoCollection.reloadData()
    }
    private func registerNib() {
        let videoNib = UINib(nibName: VideoCell.nibName, bundle: nil)
        videoCollection.register(videoNib, forCellWithReuseIdentifier: VideoCell.identifier)
    }
    private func createData(typeName: String, videoCode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let manageContext = appDelegate.persistentContainer.viewContext
        manageContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let favouriteEntity = NSEntityDescription.entity(forEntityName: "Favourite", in: manageContext)  else {
            return
        }
        let myFavourite = NSManagedObject(entity: favouriteEntity, insertInto: manageContext)
        myFavourite.setValue(typeName, forKey: "type")
        myFavourite.setValue(videoCode, forKey: "videoCode")
        
        do {
            try manageContext.save()
            
        } catch let error as NSError {
            print("couldnt save \(error)")
        }
 
    }
    private func alreadyInFavourList(videoCode: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchResult.predicate = NSPredicate(format: "videoCode = %@", videoCode)
        do {
            let data = try managedContext.fetch(fetchResult)
            if data.isEmpty {
                print("not in list")
                return false
            }
            print("in list")
            return true
        } catch {
            print(error)
        }
        return false
    }
}

extension VideoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = videoCollection.frame.width * 0.9
        let height = width * 2 / 3
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension VideoViewController: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let hintText = "VIDEO_HINT".localized()
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
        AppLaunch.completedVideoLaunch()
    }
    
}
