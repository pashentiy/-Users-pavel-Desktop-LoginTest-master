//
//  AgudaCollectionViewCell.swift
//  LoginTest
//
//  Created by Pavel Petrenko on 08/06/2019.
//  Copyright © 2019 InnovationM-Admin. All rights reserved.
//

import UIKit
import SDWebImage

class AgudaCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoOfResidentOfAguda: UIImageView!
    
    @IBOutlet weak var nameOfResidentOfAguda: UILabel!
    @IBOutlet weak var proffessionOfResidentOfAguda: UILabel!
    
    var agudaOfCellsInfoArray : [AgudaCellBluePrint] = []
    
    
    override func awakeFromNib() {
        
        self.layoutIfNeeded()
        photoOfResidentOfAguda.layoutIfNeeded()
        
        photoOfResidentOfAguda.setRounded()
        
        
        
        
        

//        photoOfResidentOfAguda.isUserInteractionEnabled = true
//        let square = photoOfResidentOfAguda.frame.size.width < photoOfResidentOfAguda.frame.height ? CGSize(width: photoOfResidentOfAguda.frame.size.width, height: photoOfResidentOfAguda.frame.size.width) : CGSize(width: photoOfResidentOfAguda.frame.size.height, height:  photoOfResidentOfAguda.frame.size.height)
//        photoOfResidentOfAguda.layer.cornerRadius = square.width/2
//        photoOfResidentOfAguda.clipsToBounds = true;
    }
    
    func setAgudaTheCell (agudaCell: AgudaCellBluePrint){
        
//        photoOfResidentOfAguda.image = UIImage(named: agudaCell.urlOFImageOfResident)
        
        self.photoOfResidentOfAguda.sd_setImage(with: URL(string: agudaCell.urlOFImageOfResident), completed: nil)
        
        
//        photoOfResidentOfAguda.layer.borderWidth = 1
//        photoOfResidentOfAguda.layer.masksToBounds = false
//        photoOfResidentOfAguda.layer.borderColor = UIColor.black.cgColor
//        photoOfResidentOfAguda.layer.cornerRadius = 120
//        photoOfResidentOfAguda.layer.masksToBounds = true
//        photoOfResidentOfAguda.layoutSubviews()
//        photoOfResidentOfAguda.setRounded()
        
        
//        photoOfResidentOfAguda.layer.cornerRadius = photoOfResidentOfAguda.frame.height / 2
//        photoOfResidentOfAguda.clipsToBounds = true
        
//        photoOfResidentOfAguda.setRounded()
        nameOfResidentOfAguda.text = agudaCell.nameDescription
        proffessionOfResidentOfAguda.text = agudaCell.proffessionalDescription
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let radius = self.frame.width/2.0
//        layer.cornerRadius = 125
//        clipsToBounds = true // This could get called in the (requiered) initializer
//        // or, ofcourse, in the interface builder if you are working with storyboards
//    }
    
}

extension UIImageView {
    
    func setRounded() {
        
            let radius = self.frame.width/2.0
            self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 249/255, green: 196/255, blue: 127/255, alpha: 1.0).cgColor // Hex Color # F9C47F
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
    }
}
