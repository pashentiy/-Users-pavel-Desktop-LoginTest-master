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
import SDWebImage
import MobileCoreServices
import DropDown
import FirebaseDatabase
import FirebaseStorage
import Photos
import Lottie

class ControlPanelViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    //setting up background view for loading animation
    @IBOutlet var backGroundView: UIView!
    
    
    //this array on ENGLISH AND HELP TO SORT THE DATA INTO DB
    var arrayOfAllDivisionsInTheAguda : [String] = ["מחלקה חדשה"]
    //this array on Hebrew AND HELP TO SHOW THE TITLES ON THE PICKER VIEW
    var arrayOfDevisionsFromUIPicker : [String] = ["מחלקה חדשה"]
    var dataThatWasPickedUp : String = ""
    var uiPickerIsClosedOfAboutUsPage : Bool = false
    
    
    var arrayOfContactUsFromUIPicker : [String] = ["שעות פתיחה יום א'","שעות פתיחה יום ב'","שעות פתיחה יום ג'","שעות פתיחה יום ד'","שעות פתיחה יום ה'","שעות פתיחה יום ו'","מס' טלפון חדש של משרד","אמייל מאפליקציה לאגודה"]
    var dataThatWasPickedUpFromContactUs : Int = -1
    var uiPickerIsClosedOfContactUsPage : Bool = false
    
    
    
    @IBOutlet weak var contactUsLabelForPresentPickerTitle: UILabel!
    @IBOutlet weak var contactUsPagePicker: UIPickerView!
    
    @IBOutlet weak var newOfficePhoneLbl: UITextField!
    @IBOutlet weak var newEmailOfficeLbl: UITextField!
    
    @IBOutlet weak var openHoursYomALbl: UITextField!
    @IBOutlet weak var openHoursYomBLbl: UITextField!
    @IBOutlet weak var openHoursYomCLbl: UITextField!
    @IBOutlet weak var openHoursYomDLbl: UITextField!
    @IBOutlet weak var openHoursYomELbl: UITextField!
    @IBOutlet weak var openHoursYomFLbl: UITextField!
    
    
    
    @IBOutlet weak var aboutUsPageView: UIView!
    @IBOutlet weak var aboutUsPageViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish: UITextField!
    @IBOutlet weak var aboutUsNameOfNewResident: UITextField!
    @IBOutlet weak var aboutUsProfessionOfNewResident: UITextField!
    @IBOutlet weak var aboutUsDivisionOfNewResident: UILabel!
    
    @IBOutlet weak var addNewResidentBtn: UIButton!
    
    @IBOutlet weak var uiPickerOfDevisions: UIPickerView!
    
    
    @IBOutlet weak var imageTest: UIImageView!
    
    var stringUrl = ""
    
    //to upload pic
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        
        setUpContactUsPageLabels()
        
        setUpForSideMenuView()
        
        setUpUIPickerTitleOfRowFromFirebase()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
            print("ready to go")
            self.uiPickerOfDevisions.delegate = self
            self.uiPickerOfDevisions.dataSource = self
            
            self.contactUsPagePicker.delegate = self
            self.contactUsPagePicker.dataSource = self
        }
        
        setUpAboutUsPageLabelToBeClickable()
        
        setUpContactUsLabelToBeClickable()
        
        
        //setup the screen when loading
        aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.isHidden = true
        uiPickerOfDevisions.isHidden = true
        addNewResidentBtn.isHidden = true
        
        
        
        imagePicker.delegate = self
        
        checkPermission()
    }
    
    //setUpContactUsPageLabels when Screen loading
    func setUpContactUsPageLabels(){
        contactUsPagePicker.isHidden = true
        
        openHoursYomALbl.isHidden = false
        
        openHoursYomBLbl.isHidden = true
        openHoursYomCLbl.isHidden = true
        openHoursYomDLbl.isHidden = true
        openHoursYomELbl.isHidden = true
        openHoursYomFLbl.isHidden = true
        newOfficePhoneLbl.isHidden = true
        newEmailOfficeLbl.isHidden = true
    }
    //screen loading animation
    func startAnimation(){
        
        var viewThatContainAnimationNewManually : UIView = UIView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        viewThatContainAnimationNewManually.backgroundColor = UIColor.init(ciColor: .white)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.9) {
            animation.stop()
            viewThatContainAnimationNewManually.removeFromSuperview()
            //self.animationView.removeFromSuperview()
        }
    }
    
    
    // from this moment we setting up all Picker Views that we have
    //setting up number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //setting up numberOfRowsInComponent in each Picker View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var tempNumberOfRowsInComponent = 0
        if pickerView == uiPickerOfDevisions{
            tempNumberOfRowsInComponent = arrayOfDevisionsFromUIPicker.count
        }
        else if pickerView == contactUsPagePicker{
            tempNumberOfRowsInComponent =  arrayOfContactUsFromUIPicker.count
        }
        return tempNumberOfRowsInComponent
    }
    //setting up titles of each Picker View
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var tempTitleOfRow : String = ""
        
        if pickerView == uiPickerOfDevisions{
            tempTitleOfRow = arrayOfDevisionsFromUIPicker[row]
        }
        else if pickerView == contactUsPagePicker{
            tempTitleOfRow =  arrayOfContactUsFromUIPicker[row]
        }
        return tempTitleOfRow
    }
    //setting up what should happen when we select some row on each Picker View
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if pickerView == uiPickerOfDevisions{
            aboutUsDivisionOfNewResident.text = arrayOfDevisionsFromUIPicker[row]
            dataThatWasPickedUp = arrayOfAllDivisionsInTheAguda[row]
            print("NOW THIS DATA WAS PICKED UP WHEN SELECT THE ROW ", dataThatWasPickedUp)
            
            if dataThatWasPickedUp == "מחלקה חדשה"{
                aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.isHidden = false
            }
            else{
                aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.text = ""
                aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.isHidden = true
            }
        }
        else if pickerView == contactUsPagePicker{
            contactUsLabelForPresentPickerTitle.text = arrayOfContactUsFromUIPicker[row]
            dataThatWasPickedUpFromContactUs = row
            
            switch dataThatWasPickedUpFromContactUs{
                case 0:
                    print(0)
                    view.endEditing(true)
                   
                    openHoursYomALbl.isHidden = false
                    
                    openHoursYomBLbl.isHidden = true
                    openHoursYomCLbl.isHidden = true
                    openHoursYomDLbl.isHidden = true
                    openHoursYomELbl.isHidden = true
                    openHoursYomFLbl.isHidden = true
                    newOfficePhoneLbl.isHidden = true
                    newEmailOfficeLbl.isHidden = true
                
                case 1:
                    print(1)
                    view.endEditing(true)
                    
                    openHoursYomALbl.isHidden = true
                    
                    openHoursYomBLbl.isHidden = false
                    
                    openHoursYomCLbl.isHidden = true
                    openHoursYomDLbl.isHidden = true
                    openHoursYomELbl.isHidden = true
                    openHoursYomFLbl.isHidden = true
                    newOfficePhoneLbl.isHidden = true
                    newEmailOfficeLbl.isHidden = true
                
                case 2:
                    print(2)
                    view.endEditing(true)
                    
                    openHoursYomALbl.isHidden = true
                    openHoursYomBLbl.isHidden = true
                    
                    openHoursYomCLbl.isHidden = false
                    
                    openHoursYomDLbl.isHidden = true
                    openHoursYomELbl.isHidden = true
                    openHoursYomFLbl.isHidden = true
                    newOfficePhoneLbl.isHidden = true
                    newEmailOfficeLbl.isHidden = true
                case 3:
                    print(3)
                    view.endEditing(true)
                    
                    openHoursYomALbl.isHidden = true
                    openHoursYomBLbl.isHidden = true
                    openHoursYomCLbl.isHidden = true
                    
                    openHoursYomDLbl.isHidden = false
                    
                    openHoursYomELbl.isHidden = true
                    openHoursYomFLbl.isHidden = true
                    newOfficePhoneLbl.isHidden = true
                    newEmailOfficeLbl.isHidden = true
                case 4:
                    print(4)
                    view.endEditing(true)
                    
                    openHoursYomALbl.isHidden = true
                    openHoursYomBLbl.isHidden = true
                    openHoursYomCLbl.isHidden = true
                    openHoursYomDLbl.isHidden = true
                    
                    openHoursYomELbl.isHidden = false
                    
                    openHoursYomFLbl.isHidden = true
                    newOfficePhoneLbl.isHidden = true
                    newEmailOfficeLbl.isHidden = true
                case 5:
                    print(5)
                    view.endEditing(true)
                    
                    openHoursYomALbl.isHidden = true
                    openHoursYomBLbl.isHidden = true
                    openHoursYomCLbl.isHidden = true
                    openHoursYomDLbl.isHidden = true
                    openHoursYomELbl.isHidden = true
                    
                    openHoursYomFLbl.isHidden = false
                    
                    newOfficePhoneLbl.isHidden = true
                    newEmailOfficeLbl.isHidden = true
                case 6:
                    print(6)
                    view.endEditing(true)
                    
                    openHoursYomALbl.isHidden = true
                    openHoursYomBLbl.isHidden = true
                    openHoursYomCLbl.isHidden = true
                    openHoursYomDLbl.isHidden = true
                    openHoursYomELbl.isHidden = true
                    openHoursYomFLbl.isHidden = true
                    
                    newOfficePhoneLbl.isHidden = false
                    
                    newEmailOfficeLbl.isHidden = true
                case 7:
                    print(7)
                    view.endEditing(true)
                    
                    openHoursYomALbl.isHidden = true
                    openHoursYomBLbl.isHidden = true
                    openHoursYomCLbl.isHidden = true
                    openHoursYomDLbl.isHidden = true
                    openHoursYomELbl.isHidden = true
                    openHoursYomFLbl.isHidden = true
                    newOfficePhoneLbl.isHidden = true
                    
                    newEmailOfficeLbl.isHidden = false
                default:
                print("Didn't found your choise")
                
            }
        }

    }
    //THE END FOR SETTING UP THE PICKER VIEWS

    
//    func changeDataOfFromContacUsPageIntoDB(){
//        Database.database().reference().child("contactUsPage/officeOpenTime").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let officeOpenTime = snapshot.value as? NSDictionary
//            print("value NSDICTIONARY 2 ", officeOpenTime)
//
//            let yomRishon = officeOpenTime?["rishon"] as? String ?? ""
//            let yomSheni = officeOpenTime?["sheni"] as? String ?? ""
//            let yomShlishi = officeOpenTime?["shlishi"] as? String ?? ""
//            let yomRevii = officeOpenTime?["revii"] as? String ?? ""
//            let yomHamishi = officeOpenTime?["hamishi"] as? String ?? ""
//            let yomShishi = officeOpenTime?["shishi"] as? String ?? ""
//            let yomShabbat = officeOpenTime?["shabat"] as? String ?? ""
//
//
//
//
//
//            print("yomRishon \(yomRishon) \n yomSheni \(yomSheni) \n yomShlishi \(yomShlishi) \n yomRevii \(yomRevii) \n yomHamishi \(yomHamishi) \n yomShishi \(yomShishi) \n yomShabbat \(yomShabbat) \n")
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    
    //hide the keyboard if touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        
        }
    
    //this func will pick up all divisions from the db and will produce it on the title Row into  UIPicker For About Us Page
    func setUpUIPickerTitleOfRowFromFirebase(){
        
        Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if ( snapshot.value is NSNull ) {
                
                // DATA WAS NOT FOUND
                print("– – – Data was not found – – –")
            }
            else{
        
                let professionsOfficeDictionaryInfo = snapshot.value as? NSDictionary
                print("value professionsOfficeDictionaryInfo ", professionsOfficeDictionaryInfo)
                

                
                for professionSnapshot in snapshot.children{
                    print(" NEW ", professionSnapshot)
                    
                    
                    let restDict = professionSnapshot as! DataSnapshot
                    
                    //all the keys of the divisions in Aguda
                    let key = restDict.key
                    print("I've Got the key -> ", key)
                    self.arrayOfAllDivisionsInTheAguda.append(key)
                    print("THIS IS MY NEW ARRAY OF ALL DIVISIONS \n", self.arrayOfAllDivisionsInTheAguda)
                    
                    let dict = restDict.value as! [String : String?]
                    
                    // DEFINE VARIABLES FOR LABELS
                    let professionOfResident = dict["profession"] as? String ?? ""
                    
                    print("THE RENEW DICTIONARY ",restDict)
                    print("THE dict value ", dict)
                    print("proffesionOfResident ", professionOfResident)

                    self.arrayOfDevisionsFromUIPicker.append(professionOfResident)

                }
            }
        })
    }
    
    @IBAction func aboutUsCheckingIfAllDataIsCorrectBtn(_ sender: Any) {
        print("CHECKING .....")
        
       
        if aboutUsNameOfNewResident.text != "" && aboutUsProfessionOfNewResident.text != "" && stringUrl != "" {
            
            //inside check if (aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish) consist only English characters because DB can save key only with english characters
            if dataThatWasPickedUp == "מחלקה חדשה"{
                
                
                //if not valid input
                if isValidInput(Input: aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.text!) == false {
                    let alert = UIAlertController(title: "", message:"שם של מחלקה חייב להיות רק באנגלית בלבד וללא רווחים", preferredStyle: UIAlertController.Style.alert)
                    let alertAction = UIAlertAction(title: "OK", style: .destructive) { (alertAction) in
                        self.aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.text = ""
                    }
                    alert.addAction(alertAction)
                 
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{//valid input
                    print("WE GOOD NOW YOU CAN TAP Add New Resident")
                    
                    dataThatWasPickedUp = aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.text!
                    print("ALL GOOD DATA BEFORE DELETING SPACE \n",dataThatWasPickedUp)
                    dataThatWasPickedUp = dataThatWasPickedUp.replacingOccurrences(of: " ", with: "")
                    print("ALL GOOD DATA AFTER DELETING SPACE \n",dataThatWasPickedUp)
                    addNewResidentBtn.isHidden = false
                }
            }
            if dataThatWasPickedUp != "מחלקה חדשה"{
                print("WE GOOD NOW YOU CAN TAP Add New Resident")
                
                print("ALL GOOD DATA BEFORE DELETING SPACE \n",dataThatWasPickedUp)
                dataThatWasPickedUp = dataThatWasPickedUp.replacingOccurrences(of: " ", with: "")
                print("ALL GOOD DATA AFTER DELETING SPACE \n",dataThatWasPickedUp)
                addNewResidentBtn.isHidden = false
                
            }
        }
        else{// if we still have some data that aren't correct
            print("YOU CAN'T UPLOAD YOU NEED TO CHANGE ....")
            let errorAlert = UIAlertController(title: "אין גישה", message: "לא מליאת משהו בצורה נכונה או בדוק את חיבור אינטרנט \n 1. שם של מחלקה חייב להיות באנגלית בלבד (רק אם במידה ובחרת לצור מחלקה חדשה ) \n 2. מלא את השם של חבר חדש באגודה בעברית \n 3. מלא את התפקיד של אותו חבר באגודה רצוי בעברית \n 4. תעלה את התמונה של אותו חבר ע''י לחיצה על כפתור Load Image", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            errorAlert.addAction(errorAction)
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
    //for About Us Page Checking if מחלקה חדשה was wrote correctly (Only English)
    func isValidInput(Input:String) -> Bool {
        print("NOW WE CHECKING YOUR TEXT INPUT")
        let myCharSet=CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let output: String = Input.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (Input == output)
        print("\(isValid)")
        
        return isValid
    }
    
     //enable to tap on the UILabel (aboutUsDivisionOfNewResident)
    func setUpAboutUsPageLabelToBeClickable(){
       
        aboutUsDivisionOfNewResident.isUserInteractionEnabled = true
        let tapGestureOnUILabel = UITapGestureRecognizer(target: self, action: #selector(tapOnUILabelForAboutUsPage))
        tapGestureOnUILabel.numberOfTapsRequired = 1
        aboutUsDivisionOfNewResident.addGestureRecognizer(tapGestureOnUILabel)
    }
    
    //enable to tap on the UILabel (contactUsLabelForPresentPickerTitle)
    func setUpContactUsLabelToBeClickable(){
        
        contactUsLabelForPresentPickerTitle.isUserInteractionEnabled = true
        let tapGestureOnUILabel = UITapGestureRecognizer(target: self, action: #selector(tapOnUILabelForContactUsPage))
        tapGestureOnUILabel.numberOfTapsRequired = 1
        contactUsLabelForPresentPickerTitle.addGestureRecognizer(tapGestureOnUILabel)
    }
    
    
    //Mark : Clickable UILabel For About Us Page
    @objc func tapOnUILabelForAboutUsPage(){
        print("you just tapped on division label")
        if uiPickerIsClosedOfAboutUsPage{//closed = true
            uiPickerOfDevisions.isHidden = uiPickerIsClosedOfAboutUsPage
            
            uiPickerIsClosedOfAboutUsPage = false
        }
        else{//open
             uiPickerOfDevisions.isHidden = uiPickerIsClosedOfAboutUsPage
            
            uiPickerIsClosedOfAboutUsPage = true
        }
        
        print("uiPickerIsOpen ", uiPickerIsClosedOfAboutUsPage)
    }
    
    //Mark : Clickable UILabel For Contact Us Page
    @objc func tapOnUILabelForContactUsPage(){
        print("you just tapped on contact us label")
        if uiPickerIsClosedOfContactUsPage{//closed = true
            contactUsPagePicker.isHidden = uiPickerIsClosedOfContactUsPage
            
            uiPickerIsClosedOfContactUsPage = false
        }
        else{//open
            contactUsPagePicker.isHidden = uiPickerIsClosedOfContactUsPage
            
            uiPickerIsClosedOfContactUsPage = true
        }
        
        print("uiPickerIsOpen ", uiPickerIsClosedOfContactUsPage)
    }
    
    
    
    var sideMenuAboutUsPageIsOpen = false
    
    @IBAction func openAboutUsViewBtn(_ sender: UIButton) {
        print(sender.tag)
        if sideMenuAboutUsPageIsOpen == false{// to -> open side View
            
            aboutUsPageViewConstraints.constant = 0
            sideMenuAboutUsPageIsOpen = true
            
            //animation
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else{ // to -> close side View
            
        
            aboutUsPageViewConstraints.constant = -300
            sideMenuAboutUsPageIsOpen = false
            
            //animation
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    func setUpForSideMenuView(){
        // set the corner radius
        aboutUsPageView.layer.cornerRadius = 3.0
        aboutUsPageView.layer.masksToBounds = false
        // set the shadow properties
        aboutUsPageView.layer.shadowColor = UIColor.black.cgColor
        aboutUsPageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        aboutUsPageView.layer.shadowOpacity = 5
        aboutUsPageView.layer.shadowRadius = 0
        
        //if you want side menuView with the shadow need to add line below instead of a line above
//        aboutUsPageView.layer.shadowRadius = 5
    }
    
    
    //to upload pic FROM THIS MOMENT
    @IBAction func loadImageBtn(_ sender: Any) {
        
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    //get permission for uploading image from your local album
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
    
    //from the moment I picked up Image from the album to the moment I post it to the FireBase Storage and grab the URL of this photo
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : AnyObject]){
        
        dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[.originalImage] as? UIImage{
            
            //meta data is
            let metaDataForImage = StorageMetadata()
            metaDataForImage.contentType = "image/png"
            
            //I want to upload the photo to storage and save it in the database
            var data = Data()
            data = pickedImage.pngData()!
            
            // Create a reference to the file you want to upload
            let imageRef = Storage.storage().reference().child("Upload from mobile/" + randomString(length: 5))
            
            //Upload the file to the path "image/randomString"
            let uploadTask = imageRef.putData(data, metadata: metaDataForImage) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    
                    //aditing string to url - grabbing the url of the photo
                    self.stringUrl = "\(url!)"
                    
                    
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
    
    //allow us to upload photos without fear that two photos would be with the same name
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    //THE END OF UPLOAD PICTURE - TO THIS MOMENT
    
    //load into data base new Resident of aguda and next it's gonna display in About Us Page
    @IBAction func addNewResidentIntoDBBtn(_ sender: Any) {
        print("into AddNEW RESIDENT DB BTN ")
        //still no was choices of division Please choose what kind of division do you want
        print("dataThatWasPickedUp is >>>>>>>>>>>> ",dataThatWasPickedUp)
        if dataThatWasPickedUp == ""{
            let aboutUsNoDivisionWasChoosenAlert = UIAlertController(title: "לא בוצע שינוי", message: "קודם כל עליך לבחור מחלקה רצויה להוספה⁄ העברה של חבר אגודה חדש / קיים", preferredStyle: .alert)
            let aboutUsNoDivisionWasChoosenAlertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            
            aboutUsNoDivisionWasChoosenAlert.addAction(aboutUsNoDivisionWasChoosenAlertAction)
            present(aboutUsNoDivisionWasChoosenAlert, animated: true, completion: nil)
            return
            
        }
        
        let alert = UIAlertController(title: "הוספה בוצע בהצלחה", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            
            self.aboutUsDivisionOfNewResident.text = "אנא בחר מחלקה"
            self.aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.text = ""
            self.aboutUsNameOfNewResident.text = ""
            self.aboutUsProfessionOfNewResident.text = ""
            self.stringUrl = ""
            self.addNewResidentBtn.isHidden = true
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
        Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //            let value = snapshot.value as? String
            //            print("value String ", value)
            if ( snapshot.value is NSNull ) {

                // DATA WAS NOT FOUND
                print("– – – Data was not found – – –")
            }
            else{
                
                if self.dataThatWasPickedUp == "מחלקה חדשה"{
                    self.dataThatWasPickedUp == self.aboutUsDivisionOfNewResidentTextFieldMustBeOnlyEnglish.text
                }

                let officeResidentDictionaryInfo = snapshot.value as? NSDictionary
                print("value officeResidentDictionaryInfo 1 ", officeResidentDictionaryInfo)



                //figure out if this is a new mikcoa or changing resident of a current mikcoa
                if officeResidentDictionaryInfo!["\(self.dataThatWasPickedUp)"] != nil{
                    print("we found this current resident , ha ha bye bye looser")



                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/\(self.dataThatWasPickedUp)/name").setValue("\(self.aboutUsNameOfNewResident.text!)")
                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/\(self.dataThatWasPickedUp)/profession").setValue("\(self.aboutUsProfessionOfNewResident.text!)")
                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/\(self.dataThatWasPickedUp)/imageUrl").setValue("\(self.stringUrl)")
                    
                    self.stringUrl = ""
                    self.tapOnUILabelForAboutUsPage()
                }
                else{//curent resident not found -> it's gonna be new resident with new profession
                    print("it's gonna be new resident with new profession")

                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/\(self.dataThatWasPickedUp)/name").setValue("\(self.aboutUsNameOfNewResident.text!)")
                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/\(self.dataThatWasPickedUp)/profession").setValue("\(self.aboutUsProfessionOfNewResident.text!)")
                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/\(self.dataThatWasPickedUp)/imageUrl").setValue("\(self.stringUrl)")

                    self.stringUrl = ""
                    self.tapOnUILabelForAboutUsPage()

                }
            }
        })
    }
    
    
//    func getDataFromFireBaseAndDisplay(){
//
//        Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            //            let value = snapshot.value as? String
//            //            print("value String ", value)
//            if ( snapshot.value is NSNull ) {
//
//                // DATA WAS NOT FOUND
//                print("– – – Data was not found – – –")
//            }
//            else{
//
//                let officeResidentDictionaryInfo = snapshot.value as? NSDictionary
//                print("value officeResidentDictionaryInfo 1 ", officeResidentDictionaryInfo)
//
//
//
//                //figure out if this is a new mikcoa or changing resident of a current mikcoa
//                if officeResidentDictionaryInfo!["dovrotTest"] != nil{
//                    print("we found this current resident")
//                }
//                else{//curent resident not found -> it's gonna be new resident with new profession
//                    print("it's gonna be new resident with new profession")
//                     Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills").setValue("dovrotTest")
//
//                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/dovrotTest").setValue("name")
//                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/dovrotTest").setValue("profession")
//                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/dovrotTest").setValue("imageUrl")
//
//
//
//
//                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/dovrotTest/name").setValue("\(self.aboutUsNameOfNewResident)")
//                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/dovrotTest/profession").setValue("\(self.aboutUsNameOfNewResident)")
//                    Database.database().reference().child("aboutUsPage/agudaOfficeProfessionalSkills/dovrotTest/imageUrl").setValue("\(self.stringUrl)")
//
//                }
//
//
//
//                for professionSnapshot in snapshot.children{
//                    print(" NEW ", professionSnapshot)
//
//
//                    let restDict = professionSnapshot as! DataSnapshot
//                    let dict = restDict.value as! [String: String?]
//
//                    // DEFINE VARIABLES FOR LABELS
//                    let nameOfResident = dict["name"] as? String ?? ""
//                    let professionOfResident = dict["profession"] as? String ?? ""
//                    let imageUrl = dict["imageUrl"] as? String ?? ""
//
//                    print("THE RENEW DICTIONARY ",restDict)
//                    print("THE dict value ", dict)
//                    print("nameOfResident ",nameOfResident)
//                    print("proffesionOfResident ", professionOfResident)
//                    print("imageUrl ", imageUrl)
//
//                }
//
//                let officeNumber = officeResidentDictionaryInfo?["officeNumber"] as? String ?? ""
//                //            self.mobileLabel.text = officeNumber
//                print("officeNumber String ", officeNumber)
//
//                let officeEmail = officeResidentDictionaryInfo?["officeEmail"] as? String ?? ""
//                //            self.officeEmailAdress = officeEmail
//                print("officeEmail String ", officeEmail)
//
//
//                //            let officeOpenTime = snapshot.value as? NSDictionary
//                //            print("THIS IS THE OfficeOpenTimeDictionary ",officeOpenTime)
//                // ...
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//
//        Database.database().reference().child("contactUsPage/officeOpenTime").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let officeOpenTime = snapshot.value as? NSDictionary
//            print("value NSDICTIONARY 2 ", officeOpenTime)
//
//            let yomRishon = officeOpenTime?["rishon"] as? String ?? ""
//            let yomSheni = officeOpenTime?["sheni"] as? String ?? ""
//            let yomShlishi = officeOpenTime?["shlishi"] as? String ?? ""
//            let yomRevii = officeOpenTime?["revii"] as? String ?? ""
//            let yomHamishi = officeOpenTime?["hamishi"] as? String ?? ""
//            let yomShishi = officeOpenTime?["shishi"] as? String ?? ""
//            let yomShabbat = officeOpenTime?["shabat"] as? String ?? ""
//
//
//            //            self.yomRishonLbl.text = yomRishon
//            //            self.yomSheniLbl.text = yomSheni
//            //            self.yomShlishiLbl.text = yomShlishi
//            //            self.yomReviiLbl.text = yomRevii
//            //            self.yomHamishiLbl.text = yomHamishi
//            //            self.yomShishiLbl.text = yomShishi
//            //            self.yomShabbatLbl.text = yomShabbat
//
//
//            print("yomRishon \(yomRishon) \n yomSheni \(yomSheni) \n yomShlishi \(yomShlishi) \n yomRevii \(yomRevii) \n yomHamishi \(yomHamishi) \n yomShishi \(yomShishi) \n yomShabbat \(yomShabbat) \n")
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//
//    }
    
    //creating a new Data at the Firebase Database for ContactUs Page
    @IBAction func createNewDataOnContactUsBtn(_ sender: UIButton) {
        
        //still no was choices Please choose what you want to change
        if dataThatWasPickedUpFromContactUs == -1{
            let contactUsNoChoiseWasSelectedAlert = UIAlertController(title: "לא בוצע שינוי", message: "\n עוד לא בחרת מה לשנות אנא לחץ קודם על 'אנא בחר שינוי רצוי' ואז תשנה את הרצוי ורק אז תלחץ על כפתור לשנות", preferredStyle: .alert)
            let contactUsAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
            contactUsNoChoiseWasSelectedAlert.addAction(contactUsAlertAction)
            present(contactUsNoChoiseWasSelectedAlert, animated: true, completion: nil)
        }
        
        
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
        
        //this pop up will appear only if was some change in one of textFields
        if insideNewOfficePhoneLbl != "" || insideNewEmailOfficeLbl != "" || insideOpenHoursYomALbl != "" || insideOpenHoursYomBLbl != "" || insideOpenHoursYomCLbl != "" || insideOpenHoursYomDLbl != "" || insideOpenHoursYomELbl != "" || insideOpenHoursYomFLbl != "" {
            let contactUsAlert = UIAlertController(title: "שינוי בוצע בהצלחה", message: "", preferredStyle: .alert)
            let contactUsAlertAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                
                self.newOfficePhoneLbl.text = ""
                self.newEmailOfficeLbl.text = ""
                
                self.openHoursYomALbl.text = ""
                self.openHoursYomBLbl.text = ""
                self.openHoursYomCLbl.text = ""
                self.openHoursYomDLbl.text = ""
                self.openHoursYomELbl.text = ""
                self.openHoursYomFLbl.text = ""
                
            }
            
            contactUsAlert.addAction(contactUsAlertAction)
            present(contactUsAlert, animated: true, completion: nil)
        }
        else{//pop up you still change nothing in textField
            let contactUsNoChnagesAlert = UIAlertController(title: "לא היה שינוי", message: "לא התבצע שינוי כי לא היה שינוי בשום טקסט אנא שנה את מה שרצוי ורק אז תלחץ על כפתור לשנות", preferredStyle: .alert)
            let contactUsAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
            contactUsNoChnagesAlert.addAction(contactUsAlertAction)
            present(contactUsNoChnagesAlert, animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //From this moment all that in comments is to Share the posts into Facebook USER not into Facebook page

//    @IBOutlet weak var controlNavigationBarFacebookPosts: UINavigationBar!
    
//    @IBOutlet weak var controlPanelnavigationItem: UINavigationItem!
    
//        //MARK:- INSTANCE VARIBALE
//        let dropDown = DropDown()
//        let picker = UIImagePickerController()
    
//        //MARK:- LIFE CYCLE CALLS
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            //         Do any additional setup after loading the view.
//            self.controlPanelnavigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(openDropDown))
//        }
    
    
//        override func viewWillAppear(_ animated: Bool) {
//            //getUserData()
//        }
    
    
  
    
        // MARK: - helper methods
    
//        @objc func openDropDown(){
//            dropDown.anchorView = self.navigationItem.rightBarButtonItem
//            dropDown.dataSource = ["Link", "Photo", "Video"]
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                switch index {
//                case 0:
//                    self.shareLink(url: URL(string: "https://cocoapods.org/pods/FacebookShare")!)
//                case 1:
//                    self.sharePhoto()
//                case 2:
//                    self.shareVideo()
//                default:
//                    break;
//                }
//            }
//            dropDown.width = 200
//            dropDown.show()
//        }
//
//
//        func shareLink(url:URL){
//            let linkshare:LinkShareContent = LinkShareContent(url: url, quote: "This is my url!")
//            let shareDialoge = ShareDialog(content: linkshare)
//            shareDialoge.mode = .browser
//            shareDialoge.completion = { result in
//                print(result)
//            }
//            do {
//            try shareDialoge.show()
//            }catch let error {
//                print(error.localizedDescription)
//            }
//        }
//
//        func sharePhoto(){
//            picker.delegate = self
//            picker.mediaTypes = [String(kUTTypeImage)]
//            picker.allowsEditing = false
//            picker.sourceType = .photoLibrary
//            self.present(picker, animated: true, completion: nil)
//        }
//
//        func shareVideo(){
//            picker.delegate = self
//            picker.mediaTypes = [String(kUTTypeMovie)]
//            picker.allowsEditing = false
//            picker.sourceType = .photoLibrary
//            self.present(picker, animated: true, completion: nil)
//        }
//
//    //something new Drop Down View let's see if it's work
//    @IBOutlet var tableViewHeight: NSLayoutConstraint!
//    @IBOutlet var tableViewYAlignment: NSLayoutConstraint!
//
//    @IBOutlet weak var dropDownView: UIView!
//
//    var allWatchlists:NSMutableArray = []
//    var animating: Bool = false
//    var dropDownViewIsDisplayed: Bool = false
//
//
//    @IBAction func oepnHideView(_ sender: UIButton) {
//
//        if (self.dropDownViewIsDisplayed) {
//            self.hideDropDownView()
//        } else {
//
//            //DROPDOWN - you can just use this portion
//            let height:CGFloat = CGFloat(self.allWatchlists.count) * 8//count tableView frame height dynamically
//            self.tableViewHeight.constant = height
//            self.tableViewYAlignment.constant = 0 //hide under navBarView
//            self.dropDownView.frame.size.height = height
//            self.dropDownView.setNeedsLayout()
//            self.showDropDownView()        }
//    }
//
//    func hideDropDownView() {
//        var yAlign: CGFloat = 0.0 //hide the dropdownview bottom view exactly same as navbarview
//        self.animateDropDownToFrame(yCoordinate: yAlign) {
//            self.dropDownViewIsDisplayed = false
//        }
//    }
//
//    func showDropDownView() {
//        //+ 10 means push the dropdownview above navbarview
//        //- 10 means push the dropdownview below navbarview - in this case we want neg value of dropdownview height
//        var yAlign: CGFloat = self.tableViewYAlignment.constant - self.tableViewHeight.constant
//        self.animateDropDownToFrame(yCoordinate: yAlign) {
//            self.dropDownViewIsDisplayed = true
//        }
//    }
    
//    func animateDropDownToFrame(yCoordinate: CGFloat, completion:@escaping () -> Void) {
//        if (!self.animating) {
//            self.animating = true
//
//            //Here is the magic happenned! Core Animation - it will animate from the item original state to the state you wished to become
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
//                self.tableViewYAlignment.constant = yCoordinate //we change the position of the dropdownview
//                self.view.layoutIfNeeded() //essential for animation carry out if not view changes abruptly
//            }, completion: { (completed: Bool) -> Void in
//                self.animating = false
//                if (completed) {
//                    completion()
//                }
//            })
//        }
//    }
    
   
}
//extension ControlPanelViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            // Use editedImage Here
//
//        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            // Use originalImage Here
//            dismiss(animated: true){
//                // if app is available
//                if UIApplication.shared.canOpenURL(URL(string: "fb://")!){
//                    let photo = Photo(image: originalImage, userGenerated: true)
//                    let content = PhotoShareContent(photos: [photo])
//                    do{
//                        try ShareDialog.show(from: self, content: content){ result in
//                            print(result)
//                        }
//                    }catch let error {
//                        print(error.localizedDescription)
//                    }
//                }else {
//                    print("app not installed")
//                    //                    UIApplication.shared.open(URL(string: "itms://itunes.apple.com/in/app/facebook/id284882215")!, options: [ : ], completionHandler: nil)
//                }
//            }
//        }
//
//        else if let videoURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//            picker.dismiss(animated: true){
//                // if app is available
//                if UIApplication.shared.canOpenURL(URL(string: "fb://")!){
//                    let video = Video(url: videoURL)
//                    let myContent = VideoShareContent(video: video)
//                    do{
//                        try ShareDialog.show(from: self, content: myContent){ result in
//                            print(result)
//                        }
//                    }catch let error {
//                        print(error.localizedDescription)
//                    }
//                }else {
//                    print("app not installed")
//                    //                  UIApplication.shared.open(URL(string: "itms://itunes.apple.com/in/app/facebook/id284882215")!, options: [ : ], completionHandler: nil)
//                }
//            }
//        }
//    }
//}
