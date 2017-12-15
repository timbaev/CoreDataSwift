//
//  Storable.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 27.11.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation
import CoreData

protocol Storable {
    func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject
}
