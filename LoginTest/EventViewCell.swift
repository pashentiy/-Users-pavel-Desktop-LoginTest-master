//
//  EventViewCell.swift
//  Aguda App
//
//  Created by Pavel Petrenko on 13/05/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {

    
    @IBOutlet weak var imageEventCell: UIImageView!
    @IBOutlet weak var descriptionEventCell: UILabel!
    
    func setEventCell(event: Event){
        
        
        imageEventCell.sd_setImage(with: URL(string: event.urlOFImageInPost ), completed: nil)
        self.imageEventCell.contentMode = .scaleAspectFit
        descriptionEventCell.text = event.description

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
