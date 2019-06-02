//
//  Event.swift
//  Aguda App
//
//  Created by Pavel Petrenko on 13/05/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class Event{//event is's class that represent the posts on the main screen
    
    var description : String
    var urlOFImageInPost : String
    var doesThisEventContainVideo : String
    
    init(urlOFImageInPost: String, description: String, doesThisEventContainVideo: String) {
        
        self.description = description
        self.urlOFImageInPost = urlOFImageInPost
        self.doesThisEventContainVideo = doesThisEventContainVideo
        
      
    }
    
}
