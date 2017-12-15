//
//  CoreDataManager.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 12.12.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    lazy var viewContext: NSManagedObjectContext = {
       return persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VKProfile")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func entity(for name: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: name, in: self.viewContext)
    }
    
}
