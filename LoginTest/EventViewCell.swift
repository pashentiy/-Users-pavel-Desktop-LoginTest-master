//
//  EventViewCell.swift
//  Aguda App
//
//  Created by Pavel Petrenko on 13/05/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import WebKit
class EventViewCell: UITableViewCell {

    
    @IBOutlet weak var webVideoView: UIWebView!
    @IBOutlet weak var imageEventCell: UIImageView!
    @IBOutlet weak var descriptionEventCell: UILabel!
    
    var eventArray : [Event] = []
    
    func setEventCell(event: Event){
        
        eventArray.append(event)
        print("currently this is my eventArray ", eventArray)
        
        //the cell will represent video
        if(event.doesThisEventContainVideo == "yes"){
            //for vide test you can put this url https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
            imageEventCell.isHidden = true
            let videoURL = URL(string: event.urlOFImageInPost)
            
            let requestObj = URLRequest(url: videoURL! as  URL)
           
            self.webVideoView.loadRequest(requestObj)
            self.webVideoView.scrollView.canCancelContentTouches = true
            
        
//            self.webVideoView.mediaTypesRequiringUserActionForPlayback = .video
            self.webVideoView.mediaPlaybackAllowsAirPlay = true
            imageEventCell.isHidden = false
        }
        else{//no video cell will not represent the video
            
            webVideoView.isHidden = true
            
            imageEventCell.sd_setImage(with: URL(string: event.urlOFImageInPost ), completed: nil)
            //        self.imageEventCell.contentMode = .scaleAspectFit
            self.imageEventCell.contentMode = .redraw
            webVideoView.isHidden = false
            
        }
        descriptionEventCell.text = event.description
       

    }
    
    //can delete it at this moment it's doing nothing
    override func awakeFromNib() {
        super.awakeFromNib()
        webVideoView.stopLoading()

    }
    
    //after the scrolling table view the cells are reuseable again and we see that image of last cell comes into the cell image of first cell this solution
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageEventCell.image = nil
        webVideoView.stopLoading()
     
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
