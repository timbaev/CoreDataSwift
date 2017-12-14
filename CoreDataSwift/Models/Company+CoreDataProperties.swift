//
//  Company+CoreDataProperties.swift
//  CoreDataSwift
//
//  Created by Ildar Zalyalov on 11.12.2017.
//  Copyright © 2017 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData

extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var age: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var employers: Set<Employer>?

}

// MARK: Generated accessors for employers
extension Company {

    @objc(addEmployersObject:)
    @NSManaged public func addToEmployers(_ value: Employer)

    @objc(removeEmployersObject:)
    @NSManaged public func removeFromEmployers(_ value: Employer)

    @objc(addEmployers:)
    @NSManaged public func addToEmployers(_ values: Set<Employer>)

    @objc(removeEmployers:)
    @NSManaged public func removeFromEmployers(_ values: Set<Employer>)

}
