////
////  Upload Pic For About Us Collection.swift
////  LoginTest
////
////  Created by Pavel Petrenko on 09/06/2019.
////  Copyright © 2019 InnovationM-Admin. All rights reserved.
////
//
//import UIKit
//import Photos
//import FirebaseDatabase
//import FirebaseStorage
//
//class UploadPicForAboutUsCollection: UIViewController{
//    
//    //to upload pic
//    let imagePicker = UIImagePickerController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        checkPermission()
//        
//    }
//    
//    
//    
//    
//    //to upload pic FROM THIS MOMENT
//    @IBAction func loadImageBtn(_ sender: Any) {
//        
//        
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//        
//    }
//    func checkPermission() {
//        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//        switch photoAuthorizationStatus {
//        case .authorized:
//            print("Access is granted by user")
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization({
//                (newStatus) in
//                print("status is \(newStatus)")
//                if newStatus ==  PHAuthorizationStatus.authorized {
//                    /* do stuff here */
//                    print("success")
//                }
//            })
//            print("It is not determined until now")
//        case .restricted:
//            // same same
//            print("User do not have access to photo album.")
//        case .denied:
//            // same same
//            print("User has denied the permission.")
//        }
//    }
//    
//    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : AnyObject]){
//        
//        dismiss(animated: true, completion: nil)
//        
//        if let pickedImage = info[.originalImage] as? UIImage{
//            //I want to upload the photo to storage and save it in the database
//            var data = Data()
//            data = pickedImage.jpegData(compressionQuality: 0.5)!
//            
//            // Create a reference to the file you want to upload
//            let imageRef = Storage.storage().reference().child("images/" + randomString(length: 5))
//            
//            //Upload the file to the path "image/randomString"
//            let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
//                guard let metadata = metadata else {
//                    // Uh-oh, an error occurred!
//                    return
//                }
//                // Metadata contains file metadata such as size, content-type.
//                let size = metadata.size
//                // You can also access to download URL after upload.
//                imageRef.downloadURL { (url, error) in
//                    print("THI IS THE URL OF PIC THAT I JUST UPLOADED AND DOWNLOADED ", url)
//                    guard let downloadURL = url else {
//                        // Uh-oh, an error occurred!
//                        return
//                    }
//                }
//            }
//            print("HELLO YOU ALMOST UPLOAD YOUR IMAGE")
//        }
//        
//    }
//    
//    func randomString(length: Int) -> String {
//        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        return String((0..<length).map{ _ in letters.randomElement()! })
//    }
//    
//    
//    ////to upload pic - TO THIS MOMENT
//}
