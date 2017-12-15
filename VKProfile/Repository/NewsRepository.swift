//
//  NewsRepository.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 08.12.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

class NewsRepository: BaseRepository {
    
    func getNews() -> [News]? {
        guard let currentUserManaged = UserRepository.currentUser, let newsSet = currentUserManaged.news else { return nil }
        var newsManaged = Array(newsSet)
        newsManaged = newsManaged.sorted(by: { $0.date < $1.date })
        return newsManaged.map { News(from: $0) }
    }
    
}
