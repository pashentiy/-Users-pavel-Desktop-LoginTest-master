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
import PromiseKit

class MainViewController: UIViewController {
    
        @IBOutlet weak var sideMenuLeadingConstraints: NSLayoutConstraint!
        @IBOutlet weak var eventsTableView: UITableView!
        @IBOutlet weak var openMenuBtn: UIButton!
        @IBOutlet weak var exitMenuBtn: UIButton!
        @IBOutlet weak var sideMenuView: UIView!
    

    var arrayOfPostsId : [String] = []
    
     var arrayOfArrayOfDictionaries : [[String:String]] = []
    var responseMessages : [String:String] = ["image" : "",
                                              "post_id" : "",
                                               "description" : "",
                                               "nopic" : "false",
                                               "notext" : "" ]
    var sizeOfArray : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getFbPostsId()
        print("<<<<<<<<<<<<<<<<<<<<< THIS IS urlOfImage BEFORE ENETRING INTO Request ",urlOFImageInPost)
        print("<<<<<<<<<<<<<<<<<<<<< THIS IS descriptionOfPost BEFORE ENETRING INTO Request ",descriptionOfPost)
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            for i in 0..<self.arrayOfPostsId.count{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//                    self.getFullFbPost(postIdNumber: self.arrayOfPostsId[i])
//                }
//            }
//
//        }
//
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//            print("<<<<<<<<<<<<<<<<<<<<< THIS IS urlOfImage After ENETRING INTO Request ",self.urlOFImageInPost)
//            print("<<<<<<<<<<<<<<<<<<<<< THIS IS descriptionOfPost After ENETRING INTO Request ",self.descriptionOfPost)
//        }
        
        
        //Delay starts to create the Array after 4 second needs to get data from Facebook Server
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

            self.eventArray = self.createArray()

            self.eventsTableView.dataSource = self
            self.eventsTableView.delegate = self
            
            self.fakeTapOnTableView()
        }
    
        
        
        //Side menu Items
        exitMenuBtn.isHidden = true
        
        //        //Added new set up Dynamic row Height of the cell
        //        eventsTableView.estimatedRowHeight = 20
        //        eventsTableView.rowHeight = UITableView.automaticDimension
        
  
        
        setUpForSideMenuView()
        
    }
    //after screen loading we still doesn't see anything so we need to tap so
    //this func will do fakeTap on the table we for display all the loading screen
    func fakeTapOnTableView (){
        let indexPath = IndexPath(row: 2, section: 0)  // change row and section according to you
        eventsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        eventsTableView.delegate?.tableView?(eventsTableView, didSelectRowAt: indexPath)
        
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
   
    
    func getFbPostsId(){ //this func fill up the arrays of arrayOfPostsId and descriptionOfPost
        print("****************** INTO getFbPostsId ********************")
        
        if(AccessToken.current != nil){

//            var authenticationToken = AccessToken.current?
//            authenticationToken = "EAAEpymiSdZAABAPNEGViAJZAIcHCrKy4wp58I3ToZAywEIYsN3aMrRI2vvHPxrecH5SQzF2pYXgefOWZCdbs5GrZAHVsKe2MuW2XeqcH1Dao0RTCSIveYC24pCZB7hvwiGg7ZCWPf5NpMz5KzyUz6OBHVSxyQHf2j4ZBWMUCKehudCc1ChrAdB4WWIjmesVL1SKgNzzvhOoGGwZDZD"
//            print("_______ ",AccessToken.current?.appId)
      
            
            //AccessToken.init(appId: "327424291272080", authenticationToken: authenticationToken, userId: nil, refreshDate: authenticationToken?.refreshDate, expirationDate: authenticationToken?.expirationDate, grantedPermissions: ["email"], declinedPermissions: [])
            
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
                        self.sizeOfArray = Int(arrayOfDataFromFB!.count)
                        
                        for i in 0..<self.sizeOfArray { //do until 2
                            
                            print("THIS IS Index ", i)
                            let firstObjectFB = arrayOfDataFromFB?[i] as! NSObject
                            print("00000000000000000000000000000000 ",firstObjectFB)
                            
                            
                            let postId = firstObjectFB.value(forKey: "id") as! String
                            self.responseMessages.updateValue(postId, forKey: "post_id")
                            self.arrayOfArrayOfDictionaries.append(self.responseMessages)
                            self.getFullFbPost(postIdNumber: postId )
                            
                            
                            self.arrayOfPostsId.append(firstObjectFB.value(forKey: "id") as! String)
                        
                            //print("222222222222222 ",firstObjectFB.value(forKey: "message"))
                            
                            //if post was without text going here
                            if firstObjectFB.value(forKey: "message") == nil{
                                print("qqqqqqqqwqqqq THIS POST WITHOUT TEXT MESSAGE")
                                //need to create a new array that will containt the messages of the post (before in getFbPostsId) func
//            **Return**                    self.descriptionOfPost.append("")
                                
                                //new one instead **Return**
                                self.arrayOfArrayOfDictionaries[i].updateValue("", forKey: "description")
                                self.arrayOfArrayOfDictionaries[i].updateValue("true", forKey: "notext")
                            }
                            else{//if post with text
                                
//               **Retunr**                 self.descriptionOfPost.append(firstObjectFB.value(forKey: "message") as! String)
                                //new one instead **Return**
                                self.arrayOfArrayOfDictionaries[i].updateValue(firstObjectFB.value(forKey: "message") as! String, forKey: "description")
                                self.arrayOfArrayOfDictionaries[i].updateValue("false", forKey: "notext")
                                
                            }
                            
                            print("++++++ ", self.sizeOfArray)
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
                
//                    print("___________ THIS IS THE \(self.j) loop")
//                    print("___________THIS IS THE \(self.j) REQUEST OF POST ID ",arrayOfPostsId[j])
                
                
                    // insert into String \(self.arrayOfPostsId[self.j])
                    let req = GraphRequest(graphPath: "\(postIdNumber)/attachments", parameters: ["fields":  "description,media,image,height,src,width,feed.limit(5)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
                req.start({ (connection, result) in
                    switch result {
                    case .failed(let error):
                        print(error)
                        
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {
                            print("__________REQUEST NUMBER \(self.j) IS SUCCESS ",responseDictionary )
                            //print(responseDictionary)
                            
                            
//                                print("__________Lenght of Response Dictionary at \(self.j) loop ",responseDictionary.count)
                                var arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
                                print(arrayOfDataFromFB?.firstObject)
                            
                                //checking if this NSArray is empty or not if Empty the FB Post come without picture else with picture
            //***NEED To change the if and else places == to != in if and change the contents
                            
                            if arrayOfDataFromFB?.firstObject == nil{
                                    print("zzzzzzzzzzzzz THIS POST DOESN'T CONTAIN PICTURE")
                                    //need to create a new array that will containt the messages of the post (before in getFbPostsId) func
                                    
                                    
                                    // !!!!!!!!!! need to rollback if nothing going good
//                                    self.urlOFImageInPost.append("")
//              **Return**          let event = Event(urlOFImageInPost: "", description: self.descriptionOfPost[self.j])
            
                                
                                
                                
//              **Return**          self.eventArray.append(event)
                                
                                    
                                        //new one instead **Return**
//              **MAYBE instead sizeOfArray arrayOfArrayOfDictionaries.count
                                    for i in 0..<self.sizeOfArray {
                                        
                                        //if every place in array where Post contain Description and don't contain Image we will put "" empty ImageURL
        //****NEED TO ADD BACK  && self.arrayOfArrayOfDictionaries[i]["description"] != "" && self.arrayOfArrayOfDictionaries[i]["image"] == "" && self.arrayOfArrayOfDictionaries[i]["notext"] == "false"
                                        
                                        if self.arrayOfArrayOfDictionaries[i]["post_id"] == postIdNumber{
                                            
                                            self.arrayOfArrayOfDictionaries[i]["image"] = ""
                                            self.arrayOfArrayOfDictionaries[i].updateValue("nopic", forKey: "true")
                                            
                                            print("+++++++ THIS IS THE index of dictionaries ",self.j)
                                            
//                                            let event = Event(urlOFImageInPost: "", description: self.arrayOfArrayOfDictionaries[self.j]["description"]!)
//                                            self.eventArray.append(event)
                                            
                                            print("+++++++++++ ~THIS IS THE INDEX self.j ",self.j)
                                            print("-_-_-_-_-_ THIS POST DON'T CONTAIN PICTURE")
                                            print("THIS IS THE arrayOfArrayOfDictionaries ",self.arrayOfArrayOfDictionaries)
                                            
                                        }
                                    }
                                    self.j = self.j + 1
                                
                                }
                                else{//the post containt picture
//                                    print("_______POST CONTAIN PICTURE AT \(self.j) Post  ")
                                    //arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
                                    print("(******* data was fetched )", arrayOfDataFromFB)
                                    
                                    print("***** THIS IS MY NEW ARRAY THAT I FETCHED *****", arrayOfDataFromFB?[0])
                                    
                                    
                                    let firstObjectFB = arrayOfDataFromFB?[0] as? NSObject
                                    print()
                                    //self.descriptionOfPost.append(firstObjectFB?.value(forKey: "description") as! String)
                                    
                                    print("******** THIS IS THE descriptionOfPost ",self.descriptionOfPost)
                                    
                                    
                                    let enteringIntoMediaObj = firstObjectFB?.value(forKey: "media") as! NSObject
                                    print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoMediaObj)
                                    let enteringIntoImageObj = enteringIntoMediaObj.value(forKey: "image") as! NSObject
                                    print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoImageObj)
                                    
//                                    self.urlOFImageInPost.append(enteringIntoImageObj.value(forKey: "src") as! String)
                                
                                
                                
                                for i in 0..<self.sizeOfArray {
                                    
                                    //if every place in array where Post contain Description and don't contain Image we will put "" empty ImageURL
            //**NEED TO ADD BACK self.arrayOfArrayOfDictionaries[i]["image"] == "" && self.arrayOfArrayOfDictionaries[i]["nopic"] == "false"
                                    if self.arrayOfArrayOfDictionaries[i]["post_id"] == postIdNumber {
                                        
                                        self.arrayOfArrayOfDictionaries[i].updateValue(enteringIntoImageObj.value(forKey: "src") as! String, forKey: "image" )
                                        
                                        ////new one instead **Return**
                                        
//                                        let event = Event(urlOFImageInPost: self.arrayOfArrayOfDictionaries[self.j]["image"]!, description: self.arrayOfArrayOfDictionaries[self.j]["description"]!)
//                                        self.eventArray.append(event)
                                        
                                        print("+++++++++++ ~THIS IS THE INDEX self.j ",self.j)
                                        print("-_-_-_-_-_ THIS POST CONTAIN PICTURE")
                                        print("THIS IS THE arrayOfArrayOfDictionaries ",self.arrayOfArrayOfDictionaries )
                                        
                                        print("******* This is the NSObject in NSArray that I fetched out \n",firstObjectFB)
                                        print("******* This is the message in NSObject that I fetched out \n",self.urlOFImageInPost)
                                        
                                    }
                                }
                                self.j = self.j + 1
                                    
                                    //insert a content of text and the url of a text only if the post has picture
//          **Return**                          let event = Event(urlOFImageInPost: enteringIntoImageObj.value(forKey: "src") as! String, description: self.descriptionOfPost[self.j])
//       **Return**                             self.eventArray.append(event)
                                
                              
                                
                            }
                        }
                    }
                })
            //}
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
//                let event = Event(urlOFImageInPost: urlOFImageInPost[i], description: descriptionOfPost[i])
//                arrTemp.append(event)
                let event = Event(urlOFImageInPost: self.arrayOfArrayOfDictionaries[i]["image"]!, description: self.arrayOfArrayOfDictionaries[i]["description"]!)
                self.eventArray.append(event)
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
            
            return eventArray
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
        
        //cell now is unselectable
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        }

}
