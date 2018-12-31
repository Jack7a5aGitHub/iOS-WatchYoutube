//
//  CoreDataModel.swift
//  BigBigBoy
//
//  Created by Jack Wong on 2018/12/17.
//  Copyright © 2018 GymMania. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataModel: NSObject {
    
    var persistentContainer: NSPersistentContainer!
    
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
    
}
