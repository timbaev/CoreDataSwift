//
//  News.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 02.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import CoreData

class News: Storable {
    
    @objc var id: Int
    @objc var text: String!
    @objc var image: UIImage?
    @objc var likeCount: Int
    @objc var commentCount: Int
    @objc var respostCount: Int
    @objc var date: Date
    
    init(id: Int = 0, text: String, image: UIImage?, likeCount: Int, commentCount: Int, respostCount: Int, date: Date = Date()) {
        self.id = id
        self.text = text
        self.image = image
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.respostCount = respostCount
        self.date = date
    }
    
    convenience init(from newsManaged: NewsManaged) {
        var image: UIImage?
        if let imageData = newsManaged.image {
            image = UIImage(data: imageData)
        }
        self.init(text: newsManaged.text, image: image, likeCount: Int(newsManaged.likeCount), commentCount: Int(newsManaged.commentCount), respostCount: Int(newsManaged.repostCount), date: newsManaged.date)
    }
    
    func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        let newsManaged = NewsManaged(context: context)
        newsManaged.text = text
        newsManaged.likeCount = Int64(likeCount)
        newsManaged.commentCount = Int64(commentCount)
        newsManaged.repostCount = Int64(respostCount)
        newsManaged.date = date
        
        var imageData: Data?
        if let image = image {
            if let convertedData = UIImageJPEGRepresentation(image, 1) {
                imageData = convertedData
            }
        }
        newsManaged.image = imageData
        return newsManaged
    }
    
}
