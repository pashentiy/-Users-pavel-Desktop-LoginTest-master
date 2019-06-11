//
//  EventViewCell.swift
//  Aguda App
//
//  Created by Pavel Petrenko on 13/05/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

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
            //for video test you can put this url https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
            imageEventCell.isHidden = true
            
            
            let videoURL = URL(string: event.urlOFImageInPost)
            
            
            var jsContext = JSContext()
            
            
            // Specify the path to the jssource.js file to disable autoPlay on video content
            if let jsSourcePath = Bundle.main.path(forResource: "autoPlayOff", ofType: "js") {
                // Specify the path to the jssource.js file.

                    do {
                        // Load its contents to a String variable.
                        let jsSourceContents = try String(contentsOfFile: jsSourcePath)

                        // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.

                     
                        let requestObj = URLRequest(url: videoURL! as  URL)
                        //            self.webVideoView.loadRequest(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: "htmlCode", ofType: "html")!) as URL) as URLRequest)
                        self.webVideoView.loadRequest(requestObj)
                           jsContext!.evaluateScript(jsSourceContents)
                        self.webVideoView.scrollView.canCancelContentTouches = true
                        //            self.webVideoView.mediaTypesRequiringUserActionForPlayback = .video
                        self.webVideoView.mediaPlaybackAllowsAirPlay = true
                        imageEventCell.isHidden = false
                    }
                    catch {
                        print(error.localizedDescription)
                }
            }
        }
        else{//no video cell will not represent the video
            //asking if the exact post doesn't contain Picture (or contain Default picture)
            if event.urlOFImageInPost == "DefaultPostPicture"{
                webVideoView.isHidden = true
                imageEventCell.image = UIImage(named: "DefaultPostPicture")
                imageEventCell.contentMode = .scaleAspectFit
                webVideoView.isHidden = false
            }
            else{
            
            webVideoView.isHidden = true
            
            imageEventCell.sd_setImage(with: URL(string: event.urlOFImageInPost ), completed: nil)
            //        self.imageEventCell.contentMode = .scaleAspectFit
            self.imageEventCell.contentMode = .redraw
            webVideoView.isHidden = false
            }
        }
        
        var string = event.description
        
        //detecting url into the array work with an extension below the class
           let myUrlFromString = string.extractURLs()
            print("yes it's contain and this is my url from string ", myUrlFromString)
            
        var attributedString = NSMutableAttributedString(string: string, attributes:[NSAttributedString.Key.link: URL(string: "http://www.google.com")!])
//
        descriptionEventCell.attributedText = attributedString
        
        descriptionEventCell.text = event.description
       

    }
    
    //can delete it at this moment it's doing nothing
    override func awakeFromNib() {
        super.awakeFromNib()
        webVideoView.stopLoading()
        var jsContext = JSContext()
        // Specify the path to the jssource.js file to disable autoPlay on video content
        if let jsSourcePath = Bundle.main.path(forResource: "autoPlayOff", ofType: "js") {
            // Specify the path to the jssource.js file.
            
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                
                jsContext!.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }

    }
    
    //after the scrolling table view the cells are reuseable again and we see that image of last cell comes into the cell image of first cell this solution
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        imageEventCell.image = nil
        webVideoView.stopLoading()
        
        var jsContext = JSContext()
        // Specify the path to the jssource.js file to disable autoPlay on video content
        if let jsSourcePath = Bundle.main.path(forResource: "autoPlayOff", ofType: "js") {
            // Specify the path to the jssource.js file.
            
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                
                jsContext!.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
     
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension String {
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}
