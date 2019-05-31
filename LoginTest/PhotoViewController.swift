//
//  PhotoViewController.swift
//  LoginTest
//
//  Created by Pavel Petrenko on 23/05/2019.
//  Copyright © 2019 InnovationM-Admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import  SDWebImage
import MobileCoreServices
import SwiftyJSON

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    
    
    var userPhotos : NSArray?
    var myCollectionView : UICollectionView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    
    var arrayOfArrayOfDictionaries : [[String:String]] = []
    var responseMessages : [String:String] = ["image" : "",
                                              "album_id" : "",
                                              "album_name" : "",
                                              "photo_id" : "",
                                              "photo_url" : "",
                                              "nopic" : "false",
                                              "without_album_name" : "",
                                              "amount_of_photos_into_this_album" : "0",
                                              "temp_amount_of_photos_into_this_album" : "0"]//amount_of_photos is indicator of how many photos will contain One Album
    var amountOfPhotosIntoThisAlbum : Int = 0
    var amountOfAlbums : Int = 0 //amount of Albums
    var amountOfPhotosIntoAllAlbums : Int = 0 //amount of Photos into whole Albums
    
    var arrayOfAlbumsId : [String] = []
    var arrayOfPhotosId : [String] = [] //photos id that stands inside the Album
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("<><><><><><><><> FROM PHOTO VIEW CONTROLLER ACCES TOKEN \(AccessToken.current)")
        //added NEW
//        // Set up collection view
//
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        //top: 20, left: 10, bottom: 10, right: 10
//        layout.sectionInset = UIEdgeInsets(top: 300, left: 300, bottom: 300, right: 300)
//        layout.itemSize = CGSize(width: 60, height: 60)
//        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        myCollectionView.dataSource = self
//        myCollectionView.delegate = self
//        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
//        myCollectionView.backgroundColor = UIColor.white
//        self.view.addSubview(myCollectionView)


        
        
        getFbAlbumsId()
       // getFbPost()
        
        
       // getContentOfFbPost()
        
        
        
        //fetchListOfUserPhotos()
        
        
        // Do any additional setup after loading the view.
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("HEY IT WAS A LONG WAY TO FETCH THE PHOTO PIC")
            print("This is the amount of Albums that we have In the end ",self.amountOfAlbums)
            print("This is the amount of Photos into all Albums that we have In the end ",self.amountOfPhotosIntoAllAlbums)
            print("THIS is the all stuff that I fetched out ", self.arrayOfArrayOfDictionaries)
            self.createPhotoArray()
            
            self.photoCollectionView.dataSource = self
            self.photoCollectionView.delegate = self

        }
        
       
        
    }
    
    
    
    @IBAction func backToMainScreenBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
      
    }
    
    //getFbAlbumsId
    func getFbAlbumsId(){
        print("****************** INTO getFbAlbumsId ********************")
        if(AccessToken.current != nil){

            
            //?limit=5 relates to the number of posts that displayed (at this state it's displayed only 5 last posts)
            let req = GraphRequest(graphPath: "424551888097352/albums", parameters: ["fields":  "created_time,name,id"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
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
                        self.amountOfAlbums = Int(arrayOfDataFromFB!.count)
                        //OPTIONAL WITHOUT THE PROFILE ALBUM
                        self.amountOfAlbums -= 1
                        print("===== amount of albums ",arrayOfDataFromFB!.count)
                        
                        for i in 0..<self.amountOfAlbums { //do until 2
                            
                            print("THIS IS Index ", i)
                            let firstObjectFB = arrayOfDataFromFB?[i] as! NSObject
                            print("00000000000000000000000000000000 ",firstObjectFB)
                            
                            
                            let albumId = firstObjectFB.value(forKey: "id") as! String
                            self.responseMessages.updateValue(albumId, forKey: "album_id")
                            self.arrayOfArrayOfDictionaries.append(self.responseMessages)
                            self.getFbPhotosIdIntoAlbums(albumIdNumber: albumId )
                            
                            
                            self.arrayOfAlbumsId.append(firstObjectFB.value(forKey: "id") as! String)
                            
                            //print("222222222222222 ",firstObjectFB.value(forKey: "message"))
                            
                            //if Album was without name going here
                            if firstObjectFB.value(forKey: "name") == nil{
                                print("qqqqqqqqwqqqq THIS Album WITHOUT NAME")
                                //need to create a new array that will containt the messages of the post (before in getFbPostsId) func
                                //            **Return**                    self.descriptionOfPost.append("")
                                
                                //new one instead **Return**
                                self.arrayOfArrayOfDictionaries[i].updateValue("", forKey: "album_name")
                                self.arrayOfArrayOfDictionaries[i].updateValue("true", forKey: "without_album_name")
                            }
                            else{//if Album has a Album name
                                
                                //               **Retunr**                 self.descriptionOfPost.append(firstObjectFB.value(forKey: "message") as! String)
                                //new one instead **Return**
                                self.arrayOfArrayOfDictionaries[i].updateValue(firstObjectFB.value(forKey: "name") as! String, forKey: "album_name")
                                self.arrayOfArrayOfDictionaries[i].updateValue("false", forKey: "without_album_name")
                                
                            }
                            
                            print("++++++ ", self.amountOfAlbums)
                            print("&&&&&&&&& This is the arrayOfAlbumsId \(self.arrayOfAlbumsId)")
                            
                        }
                        
                    }
                }
            })
        }
    }
    
    func getFbPhotosIdIntoAlbums(albumIdNumber : String){
        print("****************** INTO getFbPhotosIdIntoAlbums ********************")
        var amountOfPhotosIntoOneAlbum : Int = 0
        if(AccessToken.current != nil){
            
            print("***** THIS IS THE albumIdNumber ",albumIdNumber)
            //?limit=5 relates to the number of posts that displayed (at this state it's displayed only 5 last posts)
            let req = GraphRequest(graphPath: "\(albumIdNumber)/photos", parameters: ["fields":  "created_time,name,id"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
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
                        amountOfPhotosIntoOneAlbum = Int(arrayOfDataFromFB!.count)
                        self.amountOfPhotosIntoAllAlbums += amountOfPhotosIntoOneAlbum
                        
                        var tempAmountOfPhotoIntoDataBase = amountOfPhotosIntoOneAlbum //this variable will helps us to insert all photo id's that contain One Album
                        
                        for i in 0..<amountOfPhotosIntoOneAlbum {
                            
                            print("THIS IS Index ", i)
                            let firstObjectFB = arrayOfDataFromFB?[i] as! NSObject
                            print("00000000000000000000000000000000 ",firstObjectFB)
                            
//                            var albumName : String = ""
//                            //if album doesn't have name
//                            if firstObjectFB.value(forKey: "album_name") == nil{
//                                albumName = ""
//                            }
//                            else{
//                                 albumName = firstObjectFB.value(forKey: "album_name") as! String
//                            }
//
                            let photoIdIntoAlbum = firstObjectFB.value(forKey: "id") as! String
                            
                            //running into our DB to find exact Album and add there the photo id
                            for j in 0..<self.amountOfAlbums{
                                //checking in our data base if it's the same album, only then we will put there the Photo id's
                                if self.arrayOfArrayOfDictionaries[j]["album_id"] == albumIdNumber{
                                    //setting the album name to the exact album searching by AlbumId
//                                    self.arrayOfArrayOfDictionaries[j].updateValue(albumName, forKey: "album_name")
                                    
                                    //setting the amount of photos into the album
                                    self.arrayOfArrayOfDictionaries[j].updateValue(String(amountOfPhotosIntoOneAlbum), forKey: "amount_of_photos_into_this_album")
                                    self.arrayOfArrayOfDictionaries[j].updateValue(String(amountOfPhotosIntoOneAlbum), forKey: "temp_amount_of_photos_into_this_album")
                                    
                                    // if we still have photo id' that we need to insert , the value will be different from 0, if we have 0 value it's the sign that we have added all the photos Of Current Album into Our DB
                                    if tempAmountOfPhotoIntoDataBase != 0{
                                        self.arrayOfArrayOfDictionaries[j].updateValue(photoIdIntoAlbum, forKey: "photo_id\(tempAmountOfPhotoIntoDataBase)")
                                        tempAmountOfPhotoIntoDataBase -= 1
                                    }
                                }
                            }
//                            let photoIdIntoAlbum = firstObjectFB.value(forKey: "id") as! String
//                            self.responseMessages.updateValue(photoIdIntoAlbum, forKey: "photo_id")
//                            self.arrayOfArrayOfDictionaries.append(self.responseMessages)
                            self.getFbPhotoUrlFromPhotoId(photoIdIntoAlbumNumber: photoIdIntoAlbum, albumIdNumber: albumIdNumber)
                            
                            
//                            self.arrayOfPhotosId.append(firstObjectFB.value(forKey: "id") as! String)
//
//                            //print("222222222222222 ",firstObjectFB.value(forKey: "message"))
//
//                            //if post was without text going here
//                            if firstObjectFB.value(forKey: "name") == nil{
//                                print("qqqqqqqqwqqqq THIS ALBUM WITHOUT NAME")
//                                //need to create a new array that will containt the messages of the post (before in getFbPostsId) func
//                                //            **Return**                    self.descriptionOfPost.append("")
//
//                                //new one instead **Return**
//                                self.arrayOfArrayOfDictionaries[i].updateValue("", forKey: "album_name")
//                                self.arrayOfArrayOfDictionaries[i].updateValue("true", forKey: "without_album_name")
//                            }
//                            else{//if post with text
//
//                                //               **Retunr**                 self.descriptionOfPost.append(firstObjectFB.value(forKey: "message") as! String)
//                                //new one instead **Return**
//                                self.arrayOfArrayOfDictionaries[i].updateValue(firstObjectFB.value(forKey: "name") as! String, forKey: "album_name")
//                                self.arrayOfArrayOfDictionaries[i].updateValue("false", forKey: "without_album_name")
//
//                            }
                            
                            print("++++++ The amount of all photos into whole Albums ", self.amountOfPhotosIntoAllAlbums)
                            print("++++++ The amount of photos into One of Album ", amountOfPhotosIntoOneAlbum)
                            
                            print("&&&&&&&&& This is the arrayOfPhotosId \(self.arrayOfPhotosId)")
                            
                        }
                        
                    }
                }
            })
        }
    }
    var descriptionOfPost : [String] = []
    var urlOFImageInPost : [String] = []
    var j : Int = 0
    //This func getting full album information -  picture and message of the post getFbPhotosIdIntoAlbums
    func getFbPhotoUrlFromPhotoId(photoIdIntoAlbumNumber : String, albumIdNumber : String){
        print("****************** INTO getFbPhotoPictureFromPhotoId ********************")
        print("***** THIS IS THE photoIdIntoAlbumNumber ",photoIdIntoAlbumNumber)
        if(AccessToken.current != nil){
            //for i in 0..<arrayOfAlbumsId.count {
            
            //                    print("___________ THIS IS THE \(self.j) loop")
            //                    print("___________THIS IS THE \(self.j) REQUEST OF POST ID ",arrayOfAlbumsId[j])
            
            
            // insert into String \(self.arrayOfAlbumsId[self.j])
            let req = GraphRequest(graphPath: "\(photoIdIntoAlbumNumber)?fields=images", parameters: ["fields":  "images,height,source,width"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
            req.start({ (connection, result) in
                switch result {
                case .failed(let error):
                    print(error)
                    print("CANNOT GET THE ANSWER FROM PIC REQUEST with the photoId ",photoIdIntoAlbumNumber)
                    
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print("----- Success Get picture from PhotoIdIntoAlbumID")
                        print("__________REQUEST NUMBER \(self.j) IS SUCCESS ",responseDictionary )
                        //print(responseDictionary)
                        
                        
                        //                                print("__________Lenght of Response Dictionary at \(self.j) loop ",responseDictionary.count)
                        var arrayOfDataFromFB = responseDictionary["images"] as! NSArray?
                        print(arrayOfDataFromFB)
                        let firstObjectFB = arrayOfDataFromFB?[0] as! NSObject
                        let imageUrl = firstObjectFB.value(forKey: "source") as! String
                        
                        print("[][][][][] imageUrl " , imageUrl)
                        
                        
                        //*********** This next For Loops I don't like because it's too much heavy
                        
                        //*********** maybe we can change it to be more efficiently because the loop goes for all album every time find the exact one and take from there the temp_amount_of_photos_into_this_album EVERY SINGLE TIME !!!
                        for i in 0..<self.amountOfAlbums{
                            //firs of all we must to find the exact Album into our data base
                            if self.arrayOfArrayOfDictionaries[i]["album_id"] == albumIdNumber{
                                //now we want to know exact amount of photos into our Album
                                self.amountOfPhotosIntoThisAlbum = Int(self.arrayOfArrayOfDictionaries[i]["temp_amount_of_photos_into_this_album"]!)!
                            }
                        }
                        
                        for i in 0..<self.amountOfAlbums {
                            //firs of all we must to find the exact Album into our data base
                            if self.arrayOfArrayOfDictionaries[i]["album_id"] == albumIdNumber{
                                //now we find exact Album to insert our photo URL
                                self.arrayOfArrayOfDictionaries[i].updateValue(imageUrl, forKey: "photo_url\(self.amountOfPhotosIntoThisAlbum)")
                                self.amountOfPhotosIntoThisAlbum -= 1
                                self.arrayOfArrayOfDictionaries[i].updateValue(String(self.amountOfPhotosIntoThisAlbum), forKey: "temp_amount_of_photos_into_this_album")
                            }
                            //if every place in array where Post contain Description and don't contain Image we will put "" empty ImageURL
                            //**NEED TO ADD BACK self.arrayOfArrayOfDictionaries[i]["image"] == "" && self.arrayOfArrayOfDictionaries[i]["nopic"] == "false"
//                            if self.arrayOfArrayOfDictionaries[i]["album_id"] == photoIdIntoAlbumNumber {
//
//                                self.arrayOfArrayOfDictionaries[i].updateValue(imageUrl, forKey: "photo_url" )
//
//                                ////new one instead **Return**
//
//                                //                                        let event = Event(urlOFImageInPost: self.arrayOfArrayOfDictionaries[self.j]["image"]!, description: self.arrayOfArrayOfDictionaries[self.j]["album_name"]!)
//                                //                                        self.eventArray.append(event)
//
                                print("+++++++++++ ~THIS IS THE INDEX self.j ",self.j)
                                print("-_-_-_-_-_ THIS POST CONTAIN PICTURE")
                                print("THIS IS THE arrayOfArrayOfDictionaries ",self.arrayOfArrayOfDictionaries )
                                
                                print("******* This is the photoUrl that I fetched out \n",imageUrl)
                                print("******* This is the message in NSObject that I fetched out \n",self.urlOFImageInPost)
                                
//                            }
//                        }
//                        self.j = self.j + 1
                        //checking if this NSArray is empty or not if Empty the FB Photo inside album come without picture else with picture
                        //***NEED To change the if and else places == to != in if and change the contents
                        
//                        if arrayOfDataFromFB == nil{
//                            print("zzzzzzzzzzzzz THIS PHOTO DOESN'T CONTAIN PICTURE")
//                            //need to create a new array that will containt the messages of the post (before in getFbPostsId) func
//
//
//                            // !!!!!!!!!! need to rollback if nothing going good
//                            //                                    self.urlOFImageInPost.append("")
//                            //              **Return**          let event = Event(urlOFImageInPost: "", description: self.descriptionOfPost[self.j])
//
//
//
//
//                            //              **Return**          self.eventArray.append(event)
//
//
//                            //new one instead **Return**
//                            //              **MAYBE instead sizeOfArray arrayOfArrayOfDictionaries.count
//                            for i in 0..<self.amountOfPhotosIntoAllAlbums {
//
//                                //if every place in array where Post contain Description and don't contain Image we will put "" empty ImageURL
//                                //****NEED TO ADD BACK  && self.arrayOfArrayOfDictionaries[i]["album_name"] != "" && self.arrayOfArrayOfDictionaries[i]["image"] == "" && self.arrayOfArrayOfDictionaries[i]["without_album_name"] == "false"
//
//                                if self.arrayOfArrayOfDictionaries[i]["photo_id"] == photoIdIntoAlbumNumber{
//
//                                    self.arrayOfArrayOfDictionaries[i]["photo_url"] = ""
//                                    self.arrayOfArrayOfDictionaries[i].updateValue("nopic", forKey: "true")
//
//                                    print("+++++++ THIS IS THE index of dictionaries ",self.j)
//
//                                    //                                            let event = Event(urlOFImageInPost: "", description: self.arrayOfArrayOfDictionaries[self.j]["album_name"]!)
//                                    //                                            self.eventArray.append(event)
//
//                                    print("+++++++++++ ~THIS IS THE INDEX self.j ",self.j)
//                                    print("-_-_-_-_-_ THIS POST DON'T CONTAIN PICTURE")
//                                    print("THIS IS THE arrayOfArrayOfDictionaries ",self.arrayOfArrayOfDictionaries)
//                                    print("------THIS IS THE LAST IF ")
//
//                                }
//                            }
//                            self.j = self.j + 1
//
//                        }
//                        else{//the photoIdIntoAlbum containt picture
//                            //                                    print("_______POST CONTAIN PICTURE AT \(self.j) Post  ")
//                            //arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
//                            print("(******* data was fetched )", arrayOfDataFromFB)
//
//                            print("***** THIS IS MY NEW ARRAY THAT I FETCHED *****", arrayOfDataFromFB)
//
//
//                            let photoUrl = arrayOfDataFromFB?.value(forKey: "url") as? String
//                            print("!!!!!!!!!!!!!!!!!!!!!! This is photoUrl from /picture ",photoUrl)
//                            //self.descriptionOfPost.append(firstObjectFB?.value(forKey: "album_name") as! String)
//
//                            print("******** THIS IS THE descriptionOfPost ",self.descriptionOfPost)
//
//
////                            let enteringIntoMediaObj = firstObjectFB?.value(forKey: "media") as! NSObject
////                            print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoMediaObj)
////                            let enteringIntoImageObj = enteringIntoMediaObj.value(forKey: "image") as! NSObject
////                            print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoImageObj)
//
//                            //                                    self.urlOFImageInPost.append(enteringIntoImageObj.value(forKey: "src") as! String)
//
//
//
//                            for i in 0..<self.amountOfPhotosIntoAllAlbums {
//
//                                //if every place in array where Post contain Description and don't contain Image we will put "" empty ImageURL
//                                //**NEED TO ADD BACK self.arrayOfArrayOfDictionaries[i]["image"] == "" && self.arrayOfArrayOfDictionaries[i]["nopic"] == "false"
//                                if self.arrayOfArrayOfDictionaries[i]["album_id"] == photoIdIntoAlbumNumber {
//
//                                    self.arrayOfArrayOfDictionaries[i].updateValue(arrayOfDataFromFB?.value(forKey: "url") as! String, forKey: "photo_url" )
//
//                                    ////new one instead **Return**
//
//                                    //                                        let event = Event(urlOFImageInPost: self.arrayOfArrayOfDictionaries[self.j]["image"]!, description: self.arrayOfArrayOfDictionaries[self.j]["album_name"]!)
//                                    //                                        self.eventArray.append(event)
//
//                                    print("+++++++++++ ~THIS IS THE INDEX self.j ",self.j)
//                                    print("-_-_-_-_-_ THIS POST CONTAIN PICTURE")
//                                    print("THIS IS THE arrayOfArrayOfDictionaries ",self.arrayOfArrayOfDictionaries )
//
//                                    print("******* This is the photoUrl that I fetched out \n",photoUrl)
//                                    print("******* This is the message in NSObject that I fetched out \n",self.urlOFImageInPost)
//
//                                }
//                            }
//                            self.j = self.j + 1
                        
//        //                    insert a content of text and the url of a text only if the post has picture
//                                      **Return**                          let event = Event(urlOFImageInPost: enteringIntoImageObj.value(forKey: "src") as! String, description: self.descriptionOfPost[self.j])
//                                   **Return**                             self.eventArray.append(event)
//
//
//
//                        }
//                    }
                }
            }
            }
            })
    }
}
//    func getContentOfFbPost(){//with picture and message
//        print("****************** INTO getFbPhotosIdIntoAlbums ********************")
//
//        if(AccessToken.current != nil){
//            let req = GraphRequest(graphPath: "424551888097352_424574091428465/attachments", parameters: ["fields":  "album_name,media,image,height,src,width,feed.limit(5)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
//            req.start({ (connection, result) in
//                switch result {
//                case .failed(let error):
//                    print(error)
//
//                case .success(let graphResponse):
//                    if let responseDictionary = graphResponse.dictionaryValue {
//                        print(responseDictionary)
//
//                        let arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
//                        print("(******* data was fetched )", arrayOfDataFromFB)
//
//                        print("***** THIS IS MY NEW ARRAY THAT I FETCHED *****", arrayOfDataFromFB?[0])
//                        //let descriptionOfPost = arrayOfDataFromFB?.value(forKey: "album_name") as! NSString
//                        //self.postText.text = descriptionOfPost
//
//                        let firstObjectFB = arrayOfDataFromFB?[0] as! NSObject
//                        let descriptionOfPost = firstObjectFB.value(forKey: "album_name") as! String
//                        self.postText.text = descriptionOfPost
//
//
//                        let enteringIntoMediaObj = firstObjectFB.value(forKey: "media") as! NSObject
//                        print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoMediaObj)
//                        let enteringIntoImageObj = enteringIntoMediaObj.value(forKey: "image") as! NSObject
//                        print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoImageObj)
//                        let imageOfFBPostUrl = enteringIntoImageObj.value(forKey: "src") as! String
//                        print("******* This is the NSObject in NSArray that I fetched out \n",firstObjectFB)
//                        print("******* This is the message in NSObject that I fetched out \n",imageOfFBPostUrl)
//
//
//                        self.imageView.sd_setImage(with: URL(string: imageOfFBPostUrl ?? ""), completed: nil)
//                        self.imageView.contentMode = .scaleAspectFit
//
////                        self.postText.text = firstPostFB
//                        //
//                        //                        self.imageView.sd_setImage(with: URL(string: photoUrl ?? ""), completed: nil)
//                        //                        self.imageView.contentMode = .scaleAspectFit
//                    }
//                }
//            })
//        }
//    }
//    func getFbPost(){
//        print("****************** INTO getFbPost ********************")
//        var arrayOfAlbumsId : [String] = []
//        if(AccessToken.current != nil){
//            let req = GraphRequest(graphPath: "424551888097352/posts", parameters: ["fields":  "created_time,message,id,feed.limit(5)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
//            req.start({ (connection, result) in
//                switch result {
//                case .failed(let error):
//                    print(error)
//
//                case .success(let graphResponse):
//                    if let responseDictionary = graphResponse.dictionaryValue {
//                        print(responseDictionary)
//
//                        let arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
//                        print("(******* data was fetched )", arrayOfDataFromFB)
//                        print("@@@@ THE LENGTH OF THE ARRAY IS ", arrayOfDataFromFB?.count)
//                        var sizeOfArray = Int(arrayOfDataFromFB!.count)
//
//                        for i in 0..<sizeOfArray {
//
//                            print("THIS IS Index ", i)
//                            let firstObjectFB = arrayOfDataFromFB?[i] as! NSObject
//                            arrayOfAlbumsId.append(firstObjectFB.value(forKey: "id") as! String)
//                            print("++++++ ", sizeOfArray)
//                            print("&&&&&&&&& This is the arrayOfAlbumsId \(arrayOfAlbumsId)")
//
//                        }
//
//
////                        for n in arrayOfDataFromFB {
////
////                            arrayOfAlbumsId[index] = n["created_time"] as! String
////
////                            print("!!!!!!!!!!",arrayOfAlbumsId[index])
////                            index += 1
////                        }
//                        let firstObjectFB = arrayOfDataFromFB?[0] as! NSObject
//                        print("######## THIS IS THE arrayOfDataFromFB[0] " ,firstObjectFB)
//                        let firstPostFB = firstObjectFB.value(forKey: "message") as! String
//                        print("******* This is the NSObject in NSArray that I fetched out \n",firstObjectFB)
//                        print("******* This is the message in NSObject that I fetched out \n",firstPostFB)
//
//
//                        self.postText.text = firstPostFB
//
//                    }
//                }
    
//    func displayPhotoFromAlbum(){
//        var amountOfPhotos : Int = 0
//        for i in 0..<amountOfAlbums{
//            //first of all we find an exacat album
//            amountOfPhotos = Int(self.arrayOfArrayOfDictionaries[i]["amount_of_photos_into_this_album"]!)!
//            for j in 0..<amountOfPhotos{
//                //now we can run into the album and extract (Display all the Photos to our screen)
//                let urlToDisplayPhoto = self.arrayOfArrayOfDictionaries[i]["photo_url\(amountOfPhotos)"]
//                amountOfPhotos -= 1
//                self.arrayOfArrayOfDictionaries[i].updateValue(String(amountOfPhotos), forKey: "amount_of_photos_into_this_album")
//
//               self.imageView.sd_setImage(with: URL(string: urlToDisplayPhoto ?? ""), completed: nil)
//                self.imageView.contentMode = .scaleAspectFit
//
//            }
//
//        }
//    }
    
    
    func new(){
        
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "10217545433655215/photos", parameters: ["fields":"user_posts"] )
        
        
        graphRequest.start({ (result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
                let fbResult:[String : AnyObject] = result as! [String : AnyObject]
                
                self.userPhotos = fbResult["data"] as! NSArray?
                
                self.myCollectionView.reloadData()
            }
        })
    }
    
    
//    
//    //added new
//    func fetchListOfUserPhotos(){
//        print("*************** INTO FETCH LIST OF USER PHOTO")
//        if AccessToken.current != nil {
//            let connection = GraphRequestConnection()
//            connection.add(MyPhotoRequest()){ response, result in
//                switch result {
//                case .success(let response):
//                    //fetching user data
//                    print("fetched user: \(result)")
//                    
//                    
//                        print("*****THIS IS fbResult \(result)")
//                    
//                    
//                    //self.userPhotos = response.dict["picture"] as! NSArray?
//                    
//                    
//                        self.imageView.sd_setImage(with: URL(string: response.imageUrl ?? ""), completed: nil)
//                        self.imageView.contentMode = .scaleAspectFit
//                        //self.myCollectionView.reloadData()
//                    
//                case .failed(let error):
//                    print("Custom Graph Request Failed: \(error)")
//                }
//            }
//            connection.start()
//        }
//    }
 
    
    struct MyPhotoRequest:GraphRequestProtocol {
        // in String must to be "/me"
        var graphPath = "/me"
        var parameters: [String : Any]? = ["fields":"picture"]
        var accessToken = AccessToken.current
        var httpMethod: GraphRequestHTTPMethod = .GET
        var apiVersion: GraphAPIVersion = .defaultVersion
        
        struct  Response:GraphResponseProtocol {
            
            var dict:[String:Any]
            var imageUrl:String?
            
            init(rawResponse: Any?) {
                print("************ PHOTO CLASS Fetched User : \(rawResponse)")
                dict = rawResponse as! [String : Any]
                if let imageDict = dict["picture"] as? [String:Any]{
                    if let dataDic = imageDict["data"] as? [String:Any]{
                        if let imageURL = dataDic["url"]{
                            self.imageUrl = imageURL as! String
                            
                            
                        }
                    }
                    
                }
            }
        }
    }
    var photoDisplayArray : [PhotoInAlbum] = []
    
    func createPhotoArray(){
        var urlToDisplayPhoto = ""
        var amountOfPhotos : Int = 0
        
        for i in 0..<amountOfAlbums{
            //first of all we find an exacat album
            amountOfPhotos = Int(self.arrayOfArrayOfDictionaries[i]["amount_of_photos_into_this_album"]!)!
            for j in 0..<amountOfPhotos{
                //now we can run into the album and extract (Display all the Photos to our screen)
                urlToDisplayPhoto = self.arrayOfArrayOfDictionaries[i]["photo_url\(amountOfPhotos)"]!
                amountOfPhotos -= 1
                self.arrayOfArrayOfDictionaries[i].updateValue(String(amountOfPhotos), forKey: "amount_of_photos_into_this_album")
                
                let newPhoto = PhotoInAlbum(urlOFImageOfPhotoInAlbum: urlToDisplayPhoto)
                
                photoDisplayArray.append(newPhoto)
                
                
            }
        }
    }
    
    
                    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
                    {
        
                        return amountOfPhotosIntoAllAlbums
                    }
    
                    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                      
                        var photoEvent = photoDisplayArray[indexPath.row]

                       
                        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! PhotoCollectionViewCell
                        myCell.backgroundColor = UIColor.black
                        
                        myCell.setPhotoCell(event: photoEvent)
                        
//                        for i in 0..<amountOfAlbums{
//                            //first of all we find an exacat album
//                            amountOfPhotos = Int(self.arrayOfArrayOfDictionaries[i]["amount_of_photos_into_this_album"]!)!
//                            for j in 0..<amountOfPhotos{
//                                //now we can run into the album and extract (Display all the Photos to our screen)
//                                urlToDisplayPhoto = self.arrayOfArrayOfDictionaries[i]["photo_url\(amountOfPhotos)"]!
//                                amountOfPhotos -= 1
//                                self.arrayOfArrayOfDictionaries[i].updateValue(String(amountOfPhotos), forKey: "amount_of_photos_into_this_album")
//
//
//                                let imageUrl:NSURL? = NSURL(string: urlToDisplayPhoto)
//
//                                myCell.imagePhotoCollectionViewCell.sd_setImage(with: URL(string: urlToDisplayPhoto ?? ""), completed: nil)
//
//                                myCell.imagePhotoCollectionViewCell.contentMode = .scaleAspectFit
//
//                            }
//                        }
                        
//                        let userPhotoObject = self.userPhotos![indexPath.row] as! NSDictionary
//                        let userPhotoUrlString = userPhotoObject.value(forKey: "picture") as! String
                        
//                        let imageUrl:URL = URL(string: urlToDisplayPhoto)!
//
//                        DispatchQueue.global(qos: .userInitiated).async  {
//
//                            let imageData:Data = try! Data(contentsOf: imageUrl)
//                            let imageView = UIImageView(frame: CGRect(x: 110, y: 110, width: 100, height: 100))
//
//                            // Add photo to a cell as a subview
//                            DispatchQueue.main.async {
//                                let image = UIImage(data: imageData)
//                                imageView.image = image
//                                imageView.contentMode = UIView.ContentMode.scaleAspectFit
//                                myCell.addSubview(imageView)
//                            }
//                        }
                        
                        return myCell
                    }
    
                    /*
                     // MARK: - Navigation
     
                     // In a storyboard-based application, you will often want to do a little preparation before navigation
                     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                     // Get the new view controller using segue.destination.
                     // Pass the selected object to the new view controller.
                     }
                     */
    
}
