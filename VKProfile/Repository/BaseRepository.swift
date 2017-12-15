//
//  RepositoryManager.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 27.11.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import CoreData

class BaseRepository: Repository {
    
    func syncSave<T>(with object: T) -> Bool where T : Storable {
        let objectManaged = object.toManagedObject(in: CoreDataManager.instance.viewContext)
        if (T.self == News.self) {
            UserRepository.currentUser?.addToNews(objectManaged as! NewsManaged)
        }
        CoreDataManager.instance.saveContext()
        return true
    }
    
    func asyncSave<T>(with object: T, completionBlock: @escaping (Bool) -> ()) where T : Storable {
        CoreDataManager.instance.persistentContainer.performBackgroundTask { (context) in
            let _ = object.toManagedObject(in: context)
            do {
                try context.save()
                completionBlock(true)
            } catch {
                print(error.localizedDescription)
                completionBlock(false)
            }
        }
    }
    
    func syncGetAll<T>() -> [T]? where T : Storable {
        return getAll(in: CoreDataManager.instance.viewContext)
    }
    
    func asyncGetAll<T>(completionBlock: @escaping ([T]?) -> ()) where T : Storable {
        CoreDataManager.instance.persistentContainer.performBackgroundTask {[weak self] (context) in
            completionBlock(self?.getAll(in: context))
        }
    }
    
    private func getAll<T>(in context: NSManagedObjectContext) -> [T]? where T : Storable {
        var fetch: NSFetchRequest<NSFetchRequestResult>?
        
        if UserVK.self == T.self {
            fetch = UserManaged.fetchRequest()
        } else if News.self == T.self {
            fetch = NewsManaged.fetchRequest()
        }
        guard let fetchRequest = fetch else { return nil }
        do {
            return try context.fetch(fetchRequest) as? [T]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

