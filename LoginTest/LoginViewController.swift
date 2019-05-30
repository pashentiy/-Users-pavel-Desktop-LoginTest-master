
import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createAnArrayOfDictionaries()
        
       
    }
    
    var arrayOfArrayOfDictionaries : [[String:String]] = []
    
    func createAnArrayOfDictionaries(){
        
        var responseMessages1 : [String:String] = ["image" : "https://1image",
                                                  "descripttion" : "first description",
                                                  "post_id" : "first"]
        var responseMessages2 = ["image" : "https://2image",
                                 "descripttion" : "second description",
                                "post_id" : "second"]
        
        print(arrayOfArrayOfDictionaries)
        arrayOfArrayOfDictionaries.append(responseMessages1)
        print(arrayOfArrayOfDictionaries)
        arrayOfArrayOfDictionaries.append(responseMessages2)
        print(arrayOfArrayOfDictionaries)
       arrayOfArrayOfDictionaries[1].updateValue("NEW SECOND DESCRIPTION", forKey: "descripttion")
          print("________ ", arrayOfArrayOfDictionaries)
        print(arrayOfArrayOfDictionaries[1]["descripttion"])
        for i in 0..<arrayOfArrayOfDictionaries.count{
            if self.arrayOfArrayOfDictionaries[i]["post_id"] == "second"{
                print("------- second stantd at the index " ,i)
                
            }
            
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AccessToken.current != nil{
          
            let mvc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
            self.present(mvc!, animated: true, completion: nil)
            
        }
    }

    @IBAction func logintBtnClicked(_ sender: Any) {
        
        //asking if we already sigIn
        if AccessToken.current != nil{
            let mvc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
            self.present(mvc!, animated: true, completion: nil)

        }else{
            let manager = LoginManager()
            //added new  ReadPermission.userPosts,ReadPermission.userPhotos, ReadPermission.userBirthday
            manager.logIn(readPermissions: [ReadPermission.publicProfile,ReadPermission.email], viewController: self) { loginResult in
                
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success( _, _, _):
                    print("Logged in!")
                    print("000000000000000  MY ACCESS TOKEN IS ", AccessToken.current)
                    let mvc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                    self.present(mvc!, animated: true, completion: nil)
                }
            }
        }
        
    }
    
}

