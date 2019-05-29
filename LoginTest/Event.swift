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

class Event{
    
    var description : String
    var urlOFImageInPost : String
    
    init(urlOFImageInPost: String, description: String) {
        
        self.description = description
        self.urlOFImageInPost = urlOFImageInPost
        
      
    }
    
}
