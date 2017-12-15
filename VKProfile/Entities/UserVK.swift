//
//  UserVK.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 30.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation
import CoreData

class UserVK: NSObject, Storable {
    
    @objc var id: Int
    @objc var name: String
    @objc var surname: String
    @objc var email: String
    @objc var phoneNumber: String
    @objc var age: Int
    @objc var city: String
    @objc var password: String
    var news = [News]()
    
    init(id: Int = 0, name: String, surname: String, email: String, phoneNumber: String, age: Int, city: String, password: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phoneNumber
        self.age = age
        self.city = city
        self.password = password
    }
    
    convenience init(from managedObject: UserManaged) {
        self.init(name: managedObject.name, surname: managedObject.surname, email: managedObject.email, phoneNumber: managedObject.phoneNumber, age: Int(managedObject.age), city: managedObject.city, password: managedObject.password)
    }
    
    func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        let userManaged = UserManaged(context: context)
        userManaged.name = name
        userManaged.surname = surname
        userManaged.email = email
        userManaged.phoneNumber = phoneNumber
        userManaged.age = Int64(age)
        userManaged.city = city
        userManaged.password = password
        userManaged.news = Set<NSManagedObject>(news.map { $0.toManagedObject(in: context) }) as? Set<NewsManaged>
        return userManaged
    }
}
