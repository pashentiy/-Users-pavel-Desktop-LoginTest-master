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
    
   
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("<><><><><><><><> FROM PHOTO VIEW CONTROLLER ACCES TOKEN \(AccessToken.current)")
        //added NEW
        // Set up collection view

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
//

        
        
        //getFbId()
        getFbPost()
        
        
       // getContentOfFbPost()
        
        
        
        //fetchListOfUserPhotos()
        
        
        // Do any additional setup after loading the view.
    }
    func getFbId(){
        print("****************** INTO getFbId ********************")
        if(AccessToken.current != nil){
            let req = GraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name,gender,picture"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
            req.start({ (connection, result) in
                switch result {
                case .failed(let error):
                    print(error)
                    
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        let firstNameFB = responseDictionary["first_name"] as? String
                        let lastNameFB = responseDictionary["last_name"] as? String
                        let socialIdFB = responseDictionary["id"] as? String
                        let genderFB = responseDictionary["gender"] as? String
                        let pictureUrlFB = responseDictionary["picture"] as? [String:Any]
                        let photoData = pictureUrlFB!["data"] as? [String:Any]
                        let photoUrl = photoData!["url"] as? String
                        print("****************** ",firstNameFB, lastNameFB, socialIdFB, genderFB, photoUrl, photoData, photoUrl)
                        self.postText.text = firstNameFB
                        
                        self.imageView.sd_setImage(with: URL(string: photoUrl ?? ""), completed: nil)
                        self.imageView.contentMode = .scaleAspectFit
                    }
                }
            })
        }
    }
    func getContentOfFbPost(){//with picture and message
        print("****************** INTO getFullFbPost ********************")
        
        if(AccessToken.current != nil){
            let req = GraphRequest(graphPath: "424551888097352_424574091428465/attachments", parameters: ["fields":  "description,media,image,height,src,width,feed.limit(5)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
            req.start({ (connection, result) in
                switch result {
                case .failed(let error):
                    print(error)
                    
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        
                        let arrayOfDataFromFB = responseDictionary["data"] as! NSArray?
                        print("(******* data was fetched )", arrayOfDataFromFB)

                        print("***** THIS IS MY NEW ARRAY THAT I FETCHED *****", arrayOfDataFromFB?[0])
                        //let descriptionOfPost = arrayOfDataFromFB?.value(forKey: "description") as! NSString
                        //self.postText.text = descriptionOfPost
                        
                        let firstObjectFB = arrayOfDataFromFB?[0] as! NSObject
                        let descriptionOfPost = firstObjectFB.value(forKey: "description") as! String
                        self.postText.text = descriptionOfPost
                        
                        
                        let enteringIntoMediaObj = firstObjectFB.value(forKey: "media") as! NSObject
                        print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoMediaObj)
                        let enteringIntoImageObj = enteringIntoMediaObj.value(forKey: "image") as! NSObject
                        print("******* This is the NSObject in NSArray that I fetched out \n",enteringIntoImageObj)
                        let imageOfFBPostUrl = enteringIntoImageObj.value(forKey: "src") as! String
                        print("******* This is the NSObject in NSArray that I fetched out \n",firstObjectFB)
                        print("******* This is the message in NSObject that I fetched out \n",imageOfFBPostUrl)


                        self.imageView.sd_setImage(with: URL(string: imageOfFBPostUrl ?? ""), completed: nil)
                        self.imageView.contentMode = .scaleAspectFit
                        
//                        self.postText.text = firstPostFB
                        //
                        //                        self.imageView.sd_setImage(with: URL(string: photoUrl ?? ""), completed: nil)
                        //                        self.imageView.contentMode = .scaleAspectFit
                    }
                }
            })
        }
    }
    func getFbPost(){
        print("****************** INTO getFbPost ********************")
        var arrayOfPostsId : [String] = []
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
                            arrayOfPostsId.append(firstObjectFB.value(forKey: "id") as! String)  
                            print("++++++ ", sizeOfArray)
                            print("&&&&&&&&& This is the arrayOfPostsId \(arrayOfPostsId)")
                            
                        }
                        
                        
//                        for n in arrayOfDataFromFB {
//
//                            arrayOfPostsId[index] = n["created_time"] as! String
//
//                            print("!!!!!!!!!!",arrayOfPostsId[index])
//                            index += 1
//                        }
                        let firstObjectFB = arrayOfDataFromFB?[0] as! NSObject
                        print("######## THIS IS THE arrayOfDataFromFB[0] " ,firstObjectFB)
                        let firstPostFB = firstObjectFB.value(forKey: "message") as! String
                        print("******* This is the NSObject in NSArray that I fetched out \n",firstObjectFB)
                        print("******* This is the message in NSObject that I fetched out \n",firstPostFB)

                        
                        self.postText.text = firstPostFB

                    }
                }
            })
        }
    }
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
    
    
    
    //added new
    func fetchListOfUserPhotos(){
        print("*************** INTO FETCH LIST OF USER PHOTO")
        if AccessToken.current != nil {
            let connection = GraphRequestConnection()
            connection.add(MyPhotoRequest()){ response, result in
                switch result {
                case .success(let response):
                    //fetching user data
                    print("fetched user: \(result)")
                    
                    
                        print("*****THIS IS fbResult \(result)")
                    
                    
                    //self.userPhotos = response.dict["picture"] as! NSArray?
                    
                    
                        self.imageView.sd_setImage(with: URL(string: response.imageUrl ?? ""), completed: nil)
                        self.imageView.contentMode = .scaleAspectFit
                        //self.myCollectionView.reloadData()
                    
                case .failed(let error):
                    print("Custom Graph Request Failed: \(error)")
                }
            }
            connection.start()
        }
    }
 
    
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
                    
                    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
                    {
                        var returnValue = 0
                        
                        if let userPhotosObject = self.userPhotos
                        {
                            returnValue = userPhotosObject.count
                        }
                        
                        return returnValue
                    }
    
                    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
                        myCell.backgroundColor = UIColor.black
                        
                        let userPhotoObject = self.userPhotos![indexPath.row] as! NSDictionary
                        let userPhotoUrlString = userPhotoObject.value(forKey: "picture") as! String
                        
                        let imageUrl:URL = URL(string: userPhotoUrlString)!
                        
                        DispatchQueue.global(qos: .userInitiated).async  {
                            
                            let imageData:Data = try! Data(contentsOf: imageUrl)
                            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: myCell.frame.size.width, height: myCell.frame.size.height))
                            
                            // Add photo to a cell as a subview
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData)
                                imageView.image = image
                                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                                myCell.addSubview(imageView)
                            }
                        }
                        
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
