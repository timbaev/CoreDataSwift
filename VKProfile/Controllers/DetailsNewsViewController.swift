//
//  DetailsNewsViewController.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 27.10.2017.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

class DetailsNewsViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var news: News!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = news.text
        photoImageView.image = news.image
    }
}
