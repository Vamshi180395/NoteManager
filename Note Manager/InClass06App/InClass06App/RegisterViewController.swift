//
//  RegisterViewController.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_confirm_password: UITextField!
    let root_ref = Database.database().reference();
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func registerUserIntoFirebase(_ sender: Any) {
        if !(txt_email.text?.isEmpty)! && !(txt_password.text?.isEmpty)! && !(txt_name.text?.isEmpty)! && !(txt_confirm_password.text?.isEmpty)!{
            if(txt_password.text == txt_confirm_password.text){
            Auth.auth().createUser(withEmail: txt_email.text!, password: txt_password.text!) {(user, error) in
                if let error = error {
                    self.showAlert(displayMessage: error.localizedDescription)
                }
                else {
                    print("User signed in!")
                    let newUserRef = self.root_ref.child("NoteManager").child("Users").child((user?.uid)!)
                    let newUser = [
                        "user_email": self.txt_email.text as! NSString,
                        "user_id": user?.uid as! NSString,
                        "user_name": self.txt_name.text as! NSString,
                        "user_password": self.txt_password.text as! NSString,
                        ] as [String : Any]
                    newUserRef.setValue(newUser);
                    UserDefaults.standard.set(user?.uid, forKey: "Current_User_ID");
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let NotebooksViewController = storyboard.instantiateViewController(withIdentifier: "NavigationSB") as! UINavigationController
                    self.present(NotebooksViewController, animated: true, completion: nil)
                }
            }
            }
            else{
                self.showAlert(displayMessage: "Please ensure both the passwords match..")
            }
        }
            
        else{
            self.showAlert(displayMessage: "Please enter all the fields to proceed further..")
        }
    }
    
    func showAlert(displayMessage:String){
        let alertController = UIAlertController(title: "Error", message: displayMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
  
}
