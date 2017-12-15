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
    
    init(id: Int = 0, text: String, image: UIImage?, likeCount: Int, commentCount: Int, respostCount: Int) {
        self.id = id
        self.text = text
        self.image = image
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.respostCount = respostCount
    }
    
    convenience init(from newsManaged: NewsManaged) {
        var image: UIImage?
        if let imageData = newsManaged.image {
            image = UIImage(data: imageData)
        }
        self.init(text: newsManaged.text, image: image, likeCount: Int(newsManaged.likeCount), commentCount: Int(newsManaged.commentCount), respostCount: Int(newsManaged.repostCount))
    }
    
    func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        let newsManaged = NewsManaged(context: context)
        newsManaged.text = text
        newsManaged.likeCount = Int64(likeCount)
        newsManaged.commentCount = Int64(commentCount)
        newsManaged.repostCount = Int64(respostCount)
        
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
