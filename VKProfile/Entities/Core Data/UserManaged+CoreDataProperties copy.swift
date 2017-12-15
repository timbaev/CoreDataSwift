//
//  UserManaged+CoreDataProperties.swift
//  
//
//  Created by Тимур Шафигуллин on 13.12.17.
//
//

import Foundation
import CoreData


extension UserManaged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserManaged> {
        return NSFetchRequest<UserManaged>(entityName: "UserManaged")
    }

    @NSManaged public var age: Int64
    @NSManaged public var city: String
    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var password: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var surname: String
    @NSManaged public var news: Set<NewsManaged>?

}

// MARK: Generated accessors for news
extension UserManaged {

    @objc(addNewsObject:)
    @NSManaged public func addToNews(_ value: NewsManaged)

    @objc(removeNewsObject:)
    @NSManaged public func removeFromNews(_ value: NewsManaged)

    @objc(addNews:)
    @NSManaged public func addToNews(_ values: NSSet)

    @objc(removeNews:)
    @NSManaged public func removeFromNews(_ values: NSSet)

}
