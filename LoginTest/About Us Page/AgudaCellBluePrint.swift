//
//  File.swift
//  LoginTest
//
//  Created by Pavel Petrenko on 08/06/2019.
//  Copyright © 2019 InnovationM-Admin. All rights reserved.
//

import Foundation
import SDWebImage

class AgudaCellBluePrint{
    var nameDescription : String
    var urlOFImageOfResident : String
    var proffessionalDescription : String
    
    init(urlOFImageOfResident: String, nameDescription: String, proffessionalDescription: String) {
        
        self.nameDescription = nameDescription
        self.urlOFImageOfResident = urlOFImageOfResident
        self.proffessionalDescription = proffessionalDescription
    }
}
