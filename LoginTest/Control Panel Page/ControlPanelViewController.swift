//
//  ControlPanelViewController.swift
//  LoginTest
//
//  Created by Pavel Petrenko on 05/06/2019.
//  Copyright © 2019 InnovationM-Admin. All rights reserved.
//


import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare
import  SDWebImage
import MobileCoreServices
import DropDown

class ControlPanelViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    
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
    @IBOutlet weak var controlNavigationBarFacebookPosts: UINavigationBar!
    
    @IBOutlet weak var controlPanelnavigationItem: UINavigationItem!
    
        //MARK:- INSTANCE VARIBALE
        let dropDown = DropDown()
        let picker = UIImagePickerController()
    
        //MARK:- LIFE CYCLE CALLS
        override func viewDidLoad() {
            super.viewDidLoad()
            //         Do any additional setup after loading the view.
            self.controlPanelnavigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(openDropDown))
        }
    
    
        override func viewWillAppear(_ animated: Bool) {
            //getUserData()
        }
    
    
    
    
        // MARK: - helper methods
    
        @objc func openDropDown(){
            dropDown.anchorView = self.navigationItem.rightBarButtonItem
            dropDown.dataSource = ["Link", "Photo", "Video"]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                switch index {
                case 0:
                    self.shareLink(url: URL(string: "https://cocoapods.org/pods/FacebookShare")!)
                case 1:
                    self.sharePhoto()
                case 2:
                    self.shareVideo()
                default:
                    break;
                }
            }
            dropDown.width = 200
            dropDown.show()
        }
    
    
        func shareLink(url:URL){
            let linkshare:LinkShareContent = LinkShareContent(url: url, quote: "This is my url!")
            let shareDialoge = ShareDialog(content: linkshare)
            shareDialoge.mode = .browser
            shareDialoge.completion = { result in
                print(result)
            }
            do {
            try shareDialoge.show()
            }catch let error {
                print(error.localizedDescription)
            }
        }
    
        func sharePhoto(){
            picker.delegate = self
            picker.mediaTypes = [String(kUTTypeImage)]
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    
        func shareVideo(){
            picker.delegate = self
            picker.mediaTypes = [String(kUTTypeMovie)]
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    
    
}
extension ControlPanelViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // Use editedImage Here
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Use originalImage Here
            dismiss(animated: true){
                // if app is available
                if UIApplication.shared.canOpenURL(URL(string: "fb://")!){
                    let photo = Photo(image: originalImage, userGenerated: true)
                    let content = PhotoShareContent(photos: [photo])
                    do{
                        try ShareDialog.show(from: self, content: content){ result in
                            print(result)
                        }
                    }catch let error {
                        print(error.localizedDescription)
                    }
                }else {
                    print("app not installed")
                    //                    UIApplication.shared.open(URL(string: "itms://itunes.apple.com/in/app/facebook/id284882215")!, options: [ : ], completionHandler: nil)
                }
            }
        }
            
        else if let videoURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            picker.dismiss(animated: true){
                // if app is available
                if UIApplication.shared.canOpenURL(URL(string: "fb://")!){
                    let video = Video(url: videoURL)
                    let myContent = VideoShareContent(video: video)
                    do{
                        try ShareDialog.show(from: self, content: myContent){ result in
                            print(result)
                        }
                    }catch let error {
                        print(error.localizedDescription)
                    }
                }else {
                    print("app not installed")
                    //                  UIApplication.shared.open(URL(string: "itms://itunes.apple.com/in/app/facebook/id284882215")!, options: [ : ], completionHandler: nil)
                }
            }
        }
    }
}
