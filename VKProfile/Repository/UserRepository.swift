//
//  UserRepository.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 30.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation
import CoreData

class UserRepository: BaseRepository {
    
    static var currentUser: UserManaged?
    
    func check(with email: String, and password: String) -> UserManaged? {
        let viewContext = CoreDataManager.instance.viewContext
        let request: NSFetchRequest<UserManaged> = UserManaged.fetchRequest()
        let predicate = NSPredicate(format: "(\(#keyPath(UserManaged.email)) == %@) AND (\(#keyPath(UserManaged.password)) == %@)", email, password)
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let userManaged = try viewContext.fetch(request)
            return userManaged.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
