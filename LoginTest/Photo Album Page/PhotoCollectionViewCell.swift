//
//  PhotoCollectionViewCell.swift
//  LoginTest
//
//  Created by Pavel Petrenko on 31/05/2019.
//  Copyright © 2019 InnovationM-Admin. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imagePhotoCollectionViewCell: UIImageView!
    
    func setPhotoCell(event: PhotoInAlbum){
        
        
        imagePhotoCollectionViewCell.sd_setImage(with: URL(string: event.urlOFImageOfPhotoInAlbum ), completed: nil)
                self.imagePhotoCollectionViewCell.contentMode = .scaleAspectFit
//        self.imagePhotoCollectionViewCell.contentMode = .redraw
        //descriptionEventCell.text = event.description
        
    }
    
}
