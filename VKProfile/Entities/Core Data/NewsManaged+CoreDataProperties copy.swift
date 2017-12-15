//
//  NewsManaged+CoreDataProperties.swift
//  
//
//  Created by Тимур Шафигуллин on 13.12.17.
//
//

import Foundation
import CoreData


extension NewsManaged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsManaged> {
        return NSFetchRequest<NewsManaged>(entityName: "NewsManaged")
    }

    @NSManaged public var commentCount: Int64
    @NSManaged public var image: Data?
    @NSManaged public var likeCount: Int64
    @NSManaged public var repostCount: Int64
    @NSManaged public var text: String
    @NSManaged public var user: UserManaged
    @NSManaged public var date: Date

}
