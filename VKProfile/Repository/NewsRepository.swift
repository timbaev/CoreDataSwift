//
//  NewsRepository.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 08.12.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

class NewsRepository: BaseRepository {
    
    override init() {
        super.init()
    }
    
    func getNews() -> [News]? {
        guard let currentUserManaged = UserRepository.currentUser, let newsSet = currentUserManaged.news else { return nil }
        return newsSet.map { News(from: $0) }
    }
    
}
