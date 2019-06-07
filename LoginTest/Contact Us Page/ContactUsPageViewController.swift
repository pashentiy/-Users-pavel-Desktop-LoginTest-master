//
//  ContactUsPageViewController.swift
//  LoginTest
//
//  Created by Pavel Petrenko on 05/06/2019.
//  Copyright © 2019 InnovationM-Admin. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class ContactUsPageViewController: UIViewController {

  
    @IBOutlet weak var mobileLabel: UILabel!
    
    @IBOutlet weak var yomRishonLbl: UILabel!
    @IBOutlet weak var yomSheniLbl: UILabel!
    @IBOutlet weak var yomShlishiLbl: UILabel!
    @IBOutlet weak var yomReviiLbl: UILabel!
    @IBOutlet weak var yomHamishiLbl: UILabel!
    @IBOutlet weak var yomShishiLbl: UILabel!
    @IBOutlet weak var yomShabbatLbl: UILabel!
    
    var officeEmailAdress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFireBaseAndDisplay()
        
        
        
        //setting up the phone number to be able to tap on for make a call
        mobileLabel.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.phoneNumberLabelTap))
        
        tap.delegate = self as? UIGestureRecognizerDelegate
        mobileLabel.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    func getDataFromFireBaseAndDisplay(){
        
        Database.database().reference().child("contactUsPage").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
//            let value = snapshot.value as? String
//            print("value String ", value)
           
            
            let officeInfo = snapshot.value as? NSDictionary
            print("value NSDICTIONARY 1 ", officeInfo)
            
            let officeNumber = officeInfo?["officeNumber"] as? String ?? ""
            self.mobileLabel.text = officeNumber
            print("officeNumber String ", officeNumber)

            let officeEmail = officeInfo?["officeEmail"] as? String ?? ""
            self.officeEmailAdress = officeEmail
            print("officeEmail String ", officeEmail)
            
            
//            let officeOpenTime = snapshot.value as? NSDictionary
//            print("THIS IS THE OfficeOpenTimeDictionary ",officeOpenTime)
            // ...
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
        
        
        self.yomRishonLbl.text = yomRishon
        self.yomSheniLbl.text = yomSheni
        self.yomShlishiLbl.text = yomShlishi
        self.yomReviiLbl.text = yomRevii
        self.yomHamishiLbl.text = yomHamishi
        self.yomShishiLbl.text = yomShishi
        self.yomShabbatLbl.text = yomShabbat
        
        
        print("yomRishon \(yomRishon) \n yomSheni \(yomSheni) \n yomShlishi \(yomShlishi) \n yomRevii \(yomRevii) \n yomHamishi \(yomHamishi) \n yomShishi \(yomShishi) \n yomShabbat \(yomShabbat) \n")
        
        }) { (error) in
            print(error.localizedDescription)
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
    @IBAction func emailButtonTapped(_ sender: SAButton) {
        // This needs to be ran on a device
        showMailComposer()
    }
    //hide the keyboard it touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    func showMailComposer() {

        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }

        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([officeEmailAdress])
        composer.setSubject("כאן תכתבו שם ומספר תעודת זהות")
        composer.setMessageBody("כאן את הפנייה שלכם", isHTML: false)

        present(composer, animated: true)
    }

    
    
    
    @objc func phoneNumberLabelTap()
        
    {
        
        let phoneUrl = URL(string: "telprompt:\(mobileLabel.text ?? "")")!
        
        if(UIApplication.shared.canOpenURL(phoneUrl)) {
            
            UIApplication.shared.openURL(phoneUrl)
        }
        else {
            // create the alert
            let alert = UIAlertController(title: "Alert", message: "Cannot place call", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    //URL Redference
    @IBAction func faceBookTap(_ sender: UIButton) {
        urlReferenceForNavigationBarFindUsOn(reference: "https://www.facebook.com/aguda.jce/")
        
    }
    
    @IBAction func messengerTap(_ sender: UIButton) {
        urlReferenceForNavigationBarFindUsOn(reference: "https://www.messenger.com/t/aguda.jce")
    }
    
    @IBAction func dropBoxTap(_ sender: UIButton) {
        urlReferenceForNavigationBarFindUsOn(reference: "https://www.dropbox.com/sh/yt2y1sdmx55tlju/AAAkccJEqrUckSbvVo4lQpRra?dl=0")
    }
    
    @IBAction func whatsAppTap(_ sender: UIButton) {
        urlReferenceForNavigationBarFindUsOn(reference: "https://www.instagram.com/aguda.jce/")
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
}

extension ContactUsPageViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        }
        
        controller.dismiss(animated: true)
    }
}
