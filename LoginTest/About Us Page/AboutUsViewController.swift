//
//  AboutUsViewController.swift
//  LoginTest
//
//  Created by Pavel Petrenko on 05/06/2019.
//  Copyright © 2019 InnovationM-Admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Lottie
import Photos //to upload pic


class AboutUsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    ////to upload pic -> UIImagePickerControllerDelegate , UINavigationControllerDelegate

    @IBOutlet var backGroundView: UIView!
    @IBOutlet weak var collectionViewOfAllAguda: UICollectionView!
    
    @IBOutlet weak var whoAreWeLbl: UILabel!
    
    @IBOutlet weak var whoAreWeBigText: UITextView!
    
    @IBOutlet weak var shapeAroundTheTextImg: UIImageView!
    
   
    //to upload pic
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //start screen all labels are Hidden
        whoAreWeLbl.isHidden = true
        whoAreWeBigText.isHidden = true
        shapeAroundTheTextImg.isHidden = true
        
        
        
        checkPermission()
        imagePicker.delegate = self
       startAnimation()
        // Do any additional setup after loading the view.
       
        
        getDataFromFireBaseAndDisplay()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.createArrayOfAllAgudaInfos()
            
            self.collectionViewOfAllAguda.delegate = self
            self.collectionViewOfAllAguda.dataSource = self
            
            //end of loading screen all labels are Visible
            self.whoAreWeLbl.isHidden = false
            self.whoAreWeBigText.isHidden = false
            self.shapeAroundTheTextImg.isHidden = false
            
        }
    }
    
    //to upload pic FROM THIS MOMENT
    @IBAction func loadImageBtn(_ sender: Any) {
        
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : AnyObject]){
        
         dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[.originalImage] as? UIImage{
            //I want to upload the photo to storage and save it in the database
            var data = Data()
            data = pickedImage.jpegData(compressionQuality: 0.5)!
        
            // Create a reference to the file you want to upload
            let imageRef = Storage.storage().reference().child("images/" + randomString(length: 5))
            
            //Upload the file to the path "image/randomString"
            let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    print("THI IS THE URL OF PIC THAT I JUST UPLOADED AND DOWNLOADED ", url)
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                }
            }
            print("HELLO YOU ALMOST UPLOAD YOUR IMAGE")
        }
       
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    ////to upload pic - TO THIS MOMENT
    
    
    
    //start screen Loading animation
    func startAnimation(){
        
        var viewThatContainAnimationNewManually : UIView = UIView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        viewThatContainAnimationNewManually.backgroundColor = UIColor.init(ciColor: .clear)
        viewThatContainAnimationNewManually.layer.opacity = 1
        let animation = AnimationView(name: "loadingS5")
        //        let animation = AnimationView(name: "loadingS1")
        //animationView.contentMode = .scaleAspectFit
        backGroundView.addSubview(viewThatContainAnimationNewManually)
        
        
        animation.frame = view.frame
        
        
        viewThatContainAnimationNewManually.addSubview(animation)
        
        //        viewThatConsistAnimation.addSubview(animationView)
        animation.play()
        animation.animationSpeed = 0.8
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            animation.stop()
            viewThatContainAnimationNewManually.removeFromSuperview()
            //self.animationView.removeFromSuperview()
        }
    }
    
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var arrayOfArrayOfDictionaries : [[String:String]] = []
    var responseMessages : [String:String] = ["image" : "",
                                              "name" : "",
                                              "profession" : ""]
    
    func getDataFromFireBaseAndDisplay(){
        
        Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //            let value = snapshot.value as? String
            //            print("value String ", value)
            if ( snapshot.value is NSNull ) {
                
                // DATA WAS NOT FOUND
                print("– – – Data was not found – – –")
            }
            else{
            
            let officeResidentDictionaryInfo = snapshot.value as? NSDictionary
            print("value officeResidentDictionaryInfo 1 ", officeResidentDictionaryInfo)
            
            for professionSnapshot in snapshot.children{
                print(" NEW ", professionSnapshot)
                
                
                let restDict = professionSnapshot as! DataSnapshot
                let dict = restDict.value as! [String: String?]
                
                // DEFINE VARIABLES FOR LABELS
                let nameOfResident = dict["name"] as? String ?? ""
                let professionOfResident = dict["profession"] as? String ?? ""
                let imageUrl = dict["imageUrl"] as? String ?? ""
                
                print("THE RENEW DICTIONARY ",restDict)
                print("THE dict value ", dict)
                print("nameOfResident ",nameOfResident)
                print("proffesionOfResident ", professionOfResident)
                print("imageUrl ", imageUrl)
                
                self.responseMessages.updateValue(nameOfResident, forKey: "name")
                self.responseMessages.updateValue(professionOfResident, forKey: "profession")
                self.responseMessages.updateValue(imageUrl, forKey: "image")
                
                self.arrayOfArrayOfDictionaries.append(self.responseMessages)
            }
            
            let officeNumber = officeResidentDictionaryInfo?["officeNumber"] as? String ?? ""
//            self.mobileLabel.text = officeNumber
            print("officeNumber String ", officeNumber)
            
            let officeEmail = officeResidentDictionaryInfo?["officeEmail"] as? String ?? ""
//            self.officeEmailAdress = officeEmail
            print("officeEmail String ", officeEmail)
            
            
            //            let officeOpenTime = snapshot.value as? NSDictionary
            //            print("THIS IS THE OfficeOpenTimeDictionary ",officeOpenTime)
            // ...
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        Database.database().reference().child("contactUsPage/officeOpenTime").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let officeOpenTime = snapshot.value as? NSDictionary
            print("value NSDICTIONARY 2 ", officeOpenTime)
            
            let yomRishon = officeOpenTime?["rishon"] as? String ?? ""
            let yomSheni = officeOpenTime?["sheni"] as? String ?? ""
            let yomShlishi = officeOpenTime?["shlishi"] as? String ?? ""
            let yomRevii = officeOpenTime?["revii"] as? String ?? ""
            let yomHamishi = officeOpenTime?["hamishi"] as? String ?? ""
            let yomShishi = officeOpenTime?["shishi"] as? String ?? ""
            let yomShabbat = officeOpenTime?["shabat"] as? String ?? ""
            
            
//            self.yomRishonLbl.text = yomRishon
//            self.yomSheniLbl.text = yomSheni
//            self.yomShlishiLbl.text = yomShlishi
//            self.yomReviiLbl.text = yomRevii
//            self.yomHamishiLbl.text = yomHamishi
//            self.yomShishiLbl.text = yomShishi
//            self.yomShabbatLbl.text = yomShabbat
            
            
            print("yomRishon \(yomRishon) \n yomSheni \(yomSheni) \n yomShlishi \(yomShlishi) \n yomRevii \(yomRevii) \n yomHamishi \(yomHamishi) \n yomShishi \(yomShishi) \n yomShabbat \(yomShabbat) \n")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    var nameOfPicturesOfAguda : [String] = ["henCircleShape","noyCircleShape","itaiCircleShape","danielCircleShape","aliCircleShape","eliorCircleShape","sapirCircleShape"]
    
    var arrayOfAllAguda : [AgudaCellBluePrint] = []
    
    func createArrayOfAllAgudaInfos() -> [AgudaCellBluePrint]{
        
        for i in 0..<arrayOfArrayOfDictionaries.count{
            let agudaCell = AgudaCellBluePrint.init(urlOFImageOfResident: arrayOfArrayOfDictionaries[i]["image"]!, nameDescription: arrayOfArrayOfDictionaries[i]["name"]!, proffessionalDescription: arrayOfArrayOfDictionaries[i]["profession"]!)
            arrayOfAllAguda.append(agudaCell)
        }
        
        return arrayOfAllAguda
        
    }
    var scrollingTimer = Timer()
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAllAguda.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var agudaCell = arrayOfAllAguda[arrayOfAllAguda.count - (indexPath.row + 1)]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgudaPhotoCell", for: indexPath) as? AgudaCollectionViewCell
        
        cell?.setAgudaTheCell(agudaCell: agudaCell)
//cell?.photoOfResidentOfAguda.image = UIImage(named: "itaiCircleShape")
        
        
//        var rowIndex = indexPath.row
//        let numberOfRecords : Int = self.arrayOfAllAguda.count
//        if rowIndex < numberOfRecords{
//            rowIndex = (rowIndex + 1)
//        }
//        else{
//            rowIndex = 0
//        }
//        scrollingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(AboutUsViewController.startTimer(theTimer:)), userInfo: rowIndex, repeats: true)
        
        return cell!
    }
    
//    @objc func startTimer(theTimer: Timer){
//
//        UIView.animate(withDuration: 1.0, delay: 0, animations: {
//            self.collectionViewOfAllAguda.scrollToItem(at: IndexPath(row: (theTimer.userInfo! as! Int), section: 0), at: .centeredHorizontally, animated: true)
//            }, completion: nil)
//    }

}


//extension AboutUsViewController : UICollectionViewDataSource,UICollectionViewDelegate {
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 7
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgudaPhotoCell", for: indexPath) as? AgudaCollectionViewCell
//
//        cell?.nameOfResidentOfAguda.text = "it's me"
//
//        return cell!
//    }
//
//
//}
