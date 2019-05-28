//
//  ViewController.swift
//  Aguda App
//
//  Created by Pavel Petrenko on 10/05/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare
import  SDWebImage
import MobileCoreServices
import DropDown

class MainViewController: UIViewController {
    
        @IBOutlet weak var sideMenuLeadingConstraints: NSLayoutConstraint!
        @IBOutlet weak var eventsTableView: UITableView!
        @IBOutlet weak var openMenuBtn: UIButton!
        @IBOutlet weak var exitMenuBtn: UIButton!
        @IBOutlet weak var sideMenuView: UIView!
    

    var arrayOfPostsId : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getFbPostsId()
        print("<<<<<<<<<<<<<<<<<<<<< THIS IS urlOfImage BEFORE ENETRING INTO Request ",urlOFImageInPost)
        print("<<<<<<<<<<<<<<<<<<<<< THIS IS descriptionOfPost BEFORE ENETRING INTO Request ",descriptionOfPost)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            for i in 0..<self.arrayOfPostsId.count{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.getFullFbPost(postIdNumber: self.arrayOfPostsId[i])
                }
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            print("<<<<<<<<<<<<<<<<<<<<< THIS IS urlOfImage After ENETRING INTO Request ",self.urlOFImageInPost)
            print("<<<<<<<<<<<<<<<<<<<<< THIS IS descriptionOfPost After ENETRING INTO Request ",self.descriptionOfPost)
        }
        
        
        //Delay starts to create the Array after 4 second needs to get data from Facebook Server
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {

            self.eventArray = self.createArray()

            self.eventsTableView.dataSource = self
            self.eventsTableView.delegate = self
        }
    
        
        
        //Side menu Items
        exitMenuBtn.isHidden = true
        
        //        //Added new set up Dynamic row Height of the cell
        //        eventsTableView.estimatedRowHeight = 20
        //        eventsTableView.rowHeight = UITableView.automaticDimension
        
        setUpForSideMenuView()
        
    }
    
    //Facebook LogOut Button
    @IBAction func fbSideMenuLogOutBtn(_ sender: Any) {
            if let token = AccessToken.current {
                AccessToken.current = nil
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                self.present(loginVC!, animated: true, completion: nil)
            }
    }
    
        var eventArray : [Event] = []
        
        var sideMenuIsOpen = false
        
    func getFbPostsId(){
        print("****************** INTO getFbPostsId ********************")
        
        if(AccessToken.current != nil){
            let req = GraphRequest(graphPath: "424551888097352/posts", parameters: ["fields":  "created_time,message,id,feed.limit(5)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
            req.start({ (connection, result) in
                switch result {
                case .failed(let error):
                    print(error)
                    
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        
                        let arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
                        print("(******* data was fetched )", arrayOfDataFromFB)
                        print("@@@@ THE LENGTH OF THE ARRAY IS ", arrayOfDataFromFB?.count)
                        var sizeOfArray = Int(arrayOfDataFromFB!.count)
                        
                        for i in 0..<sizeOfArray {
                            
                            print("THIS IS Index ", i)
                            let firstObjectFB = arrayOfDataFromFB?[i] as! NSObject
                            self.arrayOfPostsId.append(firstObjectFB.value(forKey: "id") as! String)
                            print("++++++ ", sizeOfArray)
                            print("&&&&&&&&& This is the arrayOfPostsId \(self.arrayOfPostsId)")
                            
                        }
                        
                    }
                }
            })
        }
    }
    var descriptionOfPost : [String] = []
    var urlOFImageInPost : [String] = []
    var j = 0
    
    //This func getting full post information -  picture and message of the post
    func getFullFbPost(postIdNumber : String){
        print("****************** INTO getFullFbPost ********************")
        print("***** THIS IS THE arrayOfPostsId ",arrayOfPostsId)
            if(AccessToken.current != nil){
                //for i in 0..<arrayOfPostsId.count {
                
                    print("___________ THIS IS THE \(self.j) loop")
                    print("___________THIS IS THE \(self.j) REQUEST OF POST ID ",arrayOfPostsId[j])
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    let req = GraphRequest(graphPath: "\(self.arrayOfPostsId[self.j])/attachments", parameters: ["fields":  "description,media,image,height,src,width,feed.limit(5)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
                req.start({ (connection, result) in
                    switch result {
                    case .failed(let error):
                        print(error)
                        
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {
                            print("__________REQUEST NUMBER \(self.j) IS SUCCESS ",responseDictionary )
                            //print(responseDictionary)
                            
                            
                                print("__________Lenght of Response Dictionary at \(self.j) loop ",responseDictionary.count)
                                var arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
                                print(arrayOfDataFromFB?.firstObject)
                            
                                //checking if this NSArray is empty or not if Empty the FB Post come without picture else with picture
                                if arrayOfDataFromFB?.firstObject == nil{
                                    print("zzzzzzzzzzzzz THIS POST DOESN'T CONTAIN PICTURE")
                                    //need to create a new array that will containt the messages of the post (before in getFbPostsId) func
                                    self.j = self.j + 1
                                }
                                else{//the post containt picture
                                    print("_______POST CONTAIN PICTURE AT \(self.j) Post  ")
                                    //arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
                                    print("(******* data was fetched )", arrayOfDataFromFB)
                                    
                                    print("***** THIS IS MY NEW ARRAY THAT I FETCHED *****", arrayOfDataFromFB?[0])
                                    
                                    
                                    let firstObjectFB = arrayOfDataFromFB?[0] as? NSObject
                                    print()
                                    self.descriptionOfPost.append(firstObjectFB?.value(forKey: "description") as! String)
                                    
                                    print("******** THIS IS THE descriptionOfPost ",self.descriptionOfPost)
                                    
                                    
                                    let enteringIntoMediaObj = firstObjectFB?.value(forKey: "media") as! NSObject
                                    print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoMediaObj)
                                    let enteringIntoImageObj = enteringIntoMediaObj.value(forKey: "image") as! NSObject
                                    print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoImageObj)
                                    
                                    self.urlOFImageInPost.append(enteringIntoImageObj.value(forKey: "src") as! String)
                                    
                                    print("******* This is the NSObject in NSArray that I fetched out \n",firstObjectFB)
                                    print("******* This is the message in NSObject that I fetched out \n",self.urlOFImageInPost)
                                    self.j = self.j + 1
                            }
                        }
                    }
                })
            //}
                }
        }
    }
        
        func setUpForSideMenuView(){
            // set the corner radius
            sideMenuView.layer.cornerRadius = 3.0
            sideMenuView.layer.masksToBounds = false
            // set the shadow properties
            sideMenuView.layer.shadowColor = UIColor.black.cgColor
            sideMenuView.layer.shadowOffset = CGSize(width: 0, height: 0)
            sideMenuView.layer.shadowOpacity = 5
            sideMenuView.layer.shadowRadius = 5
        }
        
        //URL Redference
        @IBAction func faceBookTap(_ sender: UIButton) {
            urlReferenceForNavigationBarFindUsOn(reference: "https://www.facebook.com/aguda.jce/")
            
        }
        
        @IBAction func dropBoxTap(_ sender: UIButton) {
            urlReferenceForNavigationBarFindUsOn(reference: "https://www.dropbox.com/sh/yt2y1sdmx55tlju/AAAkccJEqrUckSbvVo4lQpRra?dl=0")
        }
        
        @IBAction func instagramTap(_ sender: UIButton) {
            urlReferenceForNavigationBarFindUsOn(reference: "https://www.instagram.com/aguda.jce/")
        }
        
        func urlReferenceForNavigationBarFindUsOn(reference : String){
            let refURL = reference
            if let url = URL(string: "\(refURL)"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        
        
        
        //Side Menu
        @IBAction func sideMenuBtn(_ sender: UIButton) {
            print(sender.tag)
            if sender.tag == 0{//Open menu button was pressed
                
                
                openMenuBtn.isHidden = true
                exitMenuBtn.isHidden = false
                sideMenuLeadingConstraints.constant = 0
                sideMenuIsOpen = true
                
                //animation
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            else{ // sender.tag == 1 Exit button was pressed
                
                
                
                openMenuBtn.isHidden = false
                exitMenuBtn.isHidden = true
                sideMenuLeadingConstraints.constant = -290
                sideMenuIsOpen = false
                
                //animation
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
                
            }
        }
    
   
    
    
    
    
        //help func that Loading the table view From local storage
        func createArray() -> [Event]{
            print("*******IN FUNC CREATE ARRAY***********")
            print("This is the urlOFImageInPost ",urlOFImageInPost)
            print("This is the descriptionOfPost ",descriptionOfPost)
            var arrTemp : [Event] = []
            
            for i in 0..<arrayOfPostsId.count{
                print("????? THIS IS THE arrayOfPostsId length ",arrayOfPostsId.count)
                print("????? THIS IS THE content of arrayOfPostsId ",arrayOfPostsId)
                print("????? THIS IS THE content of urlOFImageInPost ",urlOFImageInPost)
                print("????? THIS IS THE content of descriptionOfPost ",descriptionOfPost)
                print("????? And this is the index i ", i)
                let event = Event(urlOFImageInPost: urlOFImageInPost[i], description: descriptionOfPost[i])
                arrTemp.append(event)
                
            }
           
            
            //let event1 = Event(urlOFImageInPost: urlOFImageInPost, description: descriptionOfPost)
            
            
//            let event1 = Event(image: UIImage(named: "AlfaSpider")!, description: "This is alfa,alfa is one of the most cresative cars that can take your journey to another level")
//            let event2 = Event(image: UIImage(named: "Bugatti")!, description: "This is Bugatti - Bugati is the best car in the world, the top speed of this car is 435 km/h, it can reach from 0 to 100 km/h for just 2.2 sec. Usually people that have this car in their garage aren't sell them ,  and this another cause for raising a price with some time ")
//            let event3 = Event(image: UIImage(named: "FordMustang")!, description: "This is Ford Mustang")
//            let event4 = Event(image: UIImage(named: "RangeRover")!, description: "This is Range rover")
            
           // arrTemp.append(event1)
//            arrTemp.append(event2)
//            arrTemp.append(event3)
//            arrTemp.append(event4)
            
            return arrTemp
        }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // configuration of one cell per call
        var event = eventArray[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventViewCell
        
        cell.setEventCell(event: event)
        
        //To remove any maximum limit, and use as many lines as needed, set the value of this property to 0.
        // cell.textLabel?.numberOfLines = 0
        
        return cell
        }

}
