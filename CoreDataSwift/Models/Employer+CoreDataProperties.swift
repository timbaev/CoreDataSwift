//
//  Employer+CoreDataProperties.swift
//  CoreDataSwift
//
//  Created by Ildar Zalyalov on 11.12.2017.
//  Copyright © 2017 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData


extension Employer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employer> {
        return NSFetchRequest<Employer>(entityName: "Employer")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: Company?

}
