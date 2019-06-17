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
import ActiveLabel

class EventViewCell: UITableViewCell {

    
    @IBOutlet weak var webVideoView: UIWebView!
    @IBOutlet weak var imageEventCell: UIImageView!
    @IBOutlet weak var descriptionEventCell: ActiveLabel!
    
    
    @IBOutlet weak var contentViewAllPostsInside: UIView!
    
    var eventArray : [Event] = []
    
    func setEventCell(event: Event){
        
        //ActiveLabel()
        descriptionEventCell.isUserInteractionEnabled = true
        descriptionEventCell.numberOfLines = 0
        descriptionEventCell.enabledTypes = [.mention, .hashtag, .url]
        descriptionEventCell.textColor = .black
        descriptionEventCell.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
        }
        descriptionEventCell.urlMaximumLength = 30
        let customType = ActiveType.custom(pattern: "\\swith\\b") //Regex that looks for "with"
        descriptionEventCell.enabledTypes = [.mention, .hashtag, .url, customType]
        //descriptionEventCell.text = "This is a post with #hashtags and a @userhandle."
        descriptionEventCell.customColor[customType] = UIColor.purple
        descriptionEventCell.customSelectedColor[customType] = UIColor.green
        
        descriptionEventCell.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
            
        }
        descriptionEventCell.handleURLTap { url in UIApplication.shared.openURL(url) }
        
        //if you want customize your text from post (your UILabel) uncomment lines below
//        descriptionEventCell.customize { label in
//            descriptionEventCell.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
//            descriptionEventCell.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
//            descriptionEventCell.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
//            descriptionEventCell.URLColor = UIColor(red: 0, green: 0.8902, blue: 0.9373, alpha: 1.0)
//        }
//        
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
                imageEventCell.contentMode = .scaleToFill
                //imageEventCell.contentMode = .scaleAspectFit
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
        
        
        contentViewAllPostsInside.isUserInteractionEnabled = true


        descriptionEventCell.text = event.description
       

    }
    
    //enable to tap on the UILabel (contactUsLabelForPresentPickerTitle)
    func setUpContactUsLabelToBeClickable(){
        
        descriptionEventCell.isUserInteractionEnabled = true
        let tapGestureOnUILabel = UITapGestureRecognizer(target: self, action: #selector(tapOnUILabelForAboutUsPage))
        tapGestureOnUILabel.numberOfTapsRequired = 1
        descriptionEventCell.addGestureRecognizer(tapGestureOnUILabel)
    }
    //Mark : Clickable UILabel For Pass to URL links
    @objc func tapOnUILabelForAboutUsPage(){
        print("you just tapped on division label")
        
        
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

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

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
