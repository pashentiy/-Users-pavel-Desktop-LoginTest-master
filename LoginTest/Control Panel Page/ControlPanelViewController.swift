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
import FirebaseDatabase

class ControlPanelViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

// TEMPORARY WHEN I WILL ADD A LIST THIS GONNA DISAPPEAR
    @IBOutlet weak var newOfficePhoneLbl: UITextField!
    @IBOutlet weak var newEmailOfficeLbl: UITextField!
    
    @IBOutlet weak var openHoursYomALbl: UITextField!
    @IBOutlet weak var openHoursYomBLbl: UITextField!
    @IBOutlet weak var openHoursYomCLbl: UITextField!
    @IBOutlet weak var openHoursYomDLbl: UITextField!
    @IBOutlet weak var openHoursYomELbl: UITextField!
    @IBOutlet weak var openHoursYomFLbl: UITextField!
    
    
    //creating a new Data at the Firebase Database
    @IBAction func createNewDataOnContactUsBtn(_ sender: UIButton) {
        
        var insideNewOfficePhoneLbl = newOfficePhoneLbl.text
        var insideNewEmailOfficeLbl = newEmailOfficeLbl.text
        
        var insideOpenHoursYomALbl = openHoursYomALbl.text
        var insideOpenHoursYomBLbl = openHoursYomBLbl.text
        var insideOpenHoursYomCLbl = openHoursYomCLbl.text
        var insideOpenHoursYomDLbl = openHoursYomDLbl.text
        var insideOpenHoursYomELbl = openHoursYomELbl.text
        var insideOpenHoursYomFLbl = openHoursYomFLbl.text
        
        //cheking condition. Changing the DB only if the text label are not empty
        if insideNewOfficePhoneLbl != ""{
            Database.database().reference().child("contactUsPage/officeNumber").setValue("\(insideNewOfficePhoneLbl!)")
             print("******Was Added New Phone Number = \(insideNewOfficePhoneLbl!)")
        }
        if insideNewEmailOfficeLbl != ""{
            Database.database().reference().child("contactUsPage/officeEmail").setValue("\(insideNewEmailOfficeLbl!)")
             print("******Was Added New Email Address = \(insideNewEmailOfficeLbl!)")
        }
        
        
        
        if insideOpenHoursYomALbl != ""{
            Database.database().reference().child("contactUsPage/officeOpenTime/rishon").setValue("\(insideOpenHoursYomALbl!)")
             print("******Was Added New Open hours Yom Rishon = \(insideOpenHoursYomALbl!)")
        }
        if insideOpenHoursYomBLbl != ""{
            Database.database().reference().child("contactUsPage/officeOpenTime/sheni").setValue("\(insideOpenHoursYomBLbl!)")
             print("******Was Added New Open hours Yom Sheni = \(insideOpenHoursYomBLbl!)")
        }
        if insideOpenHoursYomCLbl != ""{
            Database.database().reference().child("contactUsPage/officeOpenTime/shlishi").setValue("\(insideOpenHoursYomCLbl!)")
             print("******Was Added New Open hours Yom Shlishi = \(insideOpenHoursYomCLbl!)")
        }
        if insideOpenHoursYomDLbl != ""{
            Database.database().reference().child("contactUsPage/officeOpenTime/revii").setValue("\(insideOpenHoursYomDLbl!)")
             print("******Was Added New Open hours Yom Revii = \(insideOpenHoursYomDLbl!)")
        }
        if insideOpenHoursYomELbl != ""{
            Database.database().reference().child("contactUsPage/officeOpenTime/hamishi").setValue("\(insideOpenHoursYomELbl!)")
             print("******Was Added New Open hours Yom Hamishi = \(insideOpenHoursYomELbl!)")
        }
        if insideOpenHoursYomFLbl != ""{
            Database.database().reference().child("contactUsPage/officeOpenTime/shishi").setValue("\(insideOpenHoursYomFLbl!)")
             print("******Was Added New Open hours Yom Shishi = \(insideOpenHoursYomFLbl!)")
        }
        
        newOfficePhoneLbl.text = ""
        newEmailOfficeLbl.text = ""
        
        openHoursYomALbl.text = ""
        openHoursYomBLbl.text = ""
        openHoursYomCLbl.text = ""
        openHoursYomDLbl.text = ""
        openHoursYomELbl.text = ""
        openHoursYomFLbl.text = ""
    }
    
    
    
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
    
    //something new Drop Down View let's see if it's work
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewYAlignment: NSLayoutConstraint!
    
    @IBOutlet weak var dropDownView: UIView!
    
    var allWatchlists:NSMutableArray = []
    var animating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    
    @IBAction func oepnHideView(_ sender: UIButton) {
        
        if (self.dropDownViewIsDisplayed) {
            self.hideDropDownView()
        } else {
            
            //DROPDOWN - you can just use this portion
            let height:CGFloat = CGFloat(self.allWatchlists.count) * 8//count tableView frame height dynamically
            self.tableViewHeight.constant = height
            self.tableViewYAlignment.constant = 0 //hide under navBarView
            self.dropDownView.frame.size.height = height
            self.dropDownView.setNeedsLayout()
            self.showDropDownView()        }
    }
    
    func hideDropDownView() {
        var yAlign: CGFloat = 0.0 //hide the dropdownview bottom view exactly same as navbarview
        self.animateDropDownToFrame(yCoordinate: yAlign) {
            self.dropDownViewIsDisplayed = false
        }
    }
    
    func showDropDownView() {
        //+ 10 means push the dropdownview above navbarview
        //- 10 means push the dropdownview below navbarview - in this case we want neg value of dropdownview height
        var yAlign: CGFloat = self.tableViewYAlignment.constant - self.tableViewHeight.constant
        self.animateDropDownToFrame(yCoordinate: yAlign) {
            self.dropDownViewIsDisplayed = true
        }
    }
    
    func animateDropDownToFrame(yCoordinate: CGFloat, completion:@escaping () -> Void) {
        if (!self.animating) {
            self.animating = true
            
            //Here is the magic happenned! Core Animation - it will animate from the item original state to the state you wished to become
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                self.tableViewYAlignment.constant = yCoordinate //we change the position of the dropdownview
                self.view.layoutIfNeeded() //essential for animation carry out if not view changes abruptly
            }, completion: { (completed: Bool) -> Void in
                self.animating = false
                if (completed) {
                    completion()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWatchlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DropDownRowCell") as! TableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = allWatchlists[indexPath.row] as? String
        return cell
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
