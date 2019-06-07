//
//  ViewController.swift
//  Firebase Login Screen
//
//  Created by Pavel Petrenko on 05/06/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import Lottie

protocol AdminMode {
    func adminModeIndicator(adminModeSwitcher : Bool)
}

class LoginFirebaseViewController: UIViewController {
    
    //delegate part for information if admin is login or not (needs for futhure permissons)
    var delegate : AdminMode?
    var adminModeSwitcher : Bool = false
    
    @IBOutlet weak var errorEmailStarLbl: UILabel!
    @IBOutlet weak var errorEmailBelowLineLbl: UILabel!
    
    @IBOutlet weak var errorPasswordStarLbl: UILabel!
    @IBOutlet weak var errorPasswordBelowLbl: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializedErrorMesage(initErrorMessage: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let errorEmailMessage = ["incorrect ! email is empty","incorrect ! email must contain @ sign"]
    
    @IBAction func loginBtn(_ sender: Any) {
        
        //hide the keyboard when tho login button is pressed
         view.endEditing(true)
        
        if emailTextField.text == "" || passwordTextField.text == ""{
            print("Missing one of the parameters email or password please complete it and do it again")
            
            //Error - lines is enabled to see
            errorEmailBelowLineLbl.text = errorEmailMessage[0]
            print("this is pop up erro of emailTextError \n" , errorEmailBelowLineLbl.text)
            errorEmailBelowLineLbl.isHidden = false
            errorEmailStarLbl.isHidden = false
            
            errorPasswordStarLbl.isHidden = false
            errorPasswordBelowLbl.isHidden = false
            
            emailTextField.text = ""
            passwordTextField.text = ""
            
        }
        else if !(emailTextField.text?.contains("@"))!{
            print("Not good Email address Because the @ sign isn't exist")
            errorEmailBelowLineLbl.text = errorEmailMessage[1]
            errorEmailStarLbl.isHidden = false
            errorEmailBelowLineLbl.isHidden = false
        }
        else{
            logUserIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    func startAnimation(access: Bool){
        
        var viewThatContainAnimationNewManually : UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        viewThatContainAnimationNewManually.backgroundColor = UIColor.init(ciColor: .white)
        viewThatContainAnimationNewManually.layer.opacity = 1
        
        
        var animation : AnimationView
        if access{
            animation = AnimationView(name: "successOk")
            
            backgroundView.addSubview(viewThatContainAnimationNewManually)
            
            
            animation.frame = view.frame
            
            viewThatContainAnimationNewManually.addSubview(animation)
            
            //        viewThatConsistAnimation.addSubview(animationView)
            animation.play()
            animation.animationSpeed = 1.3
            animation.contentMode = .scaleAspectFit
            animation.loopMode = .loop
            
           
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                animation.stop()
                self.dismiss(animated: true, completion: nil)
                viewThatContainAnimationNewManually.removeFromSuperview()
                //self.animationView.removeFromSuperview()
            }
            initializedErrorMesage(initErrorMessage: true)
        }
        else{
            animation = AnimationView(name: "animation-w80-h80")
            
            backgroundView.addSubview(viewThatContainAnimationNewManually)
            
            
            animation.frame = view.frame
            
            viewThatContainAnimationNewManually.addSubview(animation)
            
            //        viewThatConsistAnimation.addSubview(animationView)
            animation.play()
            animation.animationSpeed = 0.8
            animation.contentMode = .scaleAspectFit
            animation.loopMode = .loop
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                animation.stop()
                viewThatContainAnimationNewManually.removeFromSuperview()
                //self.animationView.removeFromSuperview()
            }
        }
        //        let animation = AnimationView(name: "loadingS1")
        //animationView.contentMode = .scaleAspectFit
        
        initializedErrorMesage(initErrorMessage: true)
        
        
        
    }
    //hide the keyboard it touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func logUserIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.startAnimation(access: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // self.dismiss(animated: true, completion: nil)
//                    let loginSuccessfullScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorLoginViewController") as? ErrorLoginViewController
//                    self.present(loginSuccessfullScreenVC!, animated: true, completion: nil)
                    
                }
                return
            }
            else{
                //                let loginSuccessfullScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "SuccessfullSignInViewController") as? SuccessfullSignInViewController
                //                self.present(loginSuccessfullScreenVC!, animated: true, completion: nil)
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.startAnimation(access: true)
            }
            //            guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
            //            guard let controller = navController.viewControllers[0] as? HomeController else { return }
            //            controller.configureViewComponents()
            //
            //            // forgot to add this in video
            //            controller.loadUserData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //to pass data backward for indicate that now is a manager logged in
                self.delegate?.adminModeIndicator(adminModeSwitcher: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
   
    //if this func get true all Error message is Hidden , False all Error message is avaliable
    func initializedErrorMesage(initErrorMessage : Bool){
        errorEmailStarLbl.isHidden = initErrorMessage
        errorEmailBelowLineLbl.isHidden = initErrorMessage
        errorPasswordStarLbl.isHidden = initErrorMessage
        errorPasswordBelowLbl.isHidden = initErrorMessage
    }
}

