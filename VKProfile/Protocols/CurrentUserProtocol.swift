//
//  CurrentUserProtocol.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 14.12.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

protocol CurrentUserProtocol {
    static var currentUser: UserManaged? { set get }
}
