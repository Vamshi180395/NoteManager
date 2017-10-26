//
//  LoginViewController.swift
//  InClass06App
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/20/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    var current_user_uid : String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "Current_User_ID");
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let NotebooksViewController = storyboard.instantiateViewController(withIdentifier: "NavigationSB") as! UINavigationController
             DispatchQueue.main.async {
            self.present(NotebooksViewController, animated: true, completion: nil)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_to_notebooks"{
            if let notebboksvc = segue.destination as? NotebooksViewController{
                notebboksvc.current_user_id = current_user_uid;
            }
        }
    }*/
    
    func showAlert(displayMessage:String){
        let alertController = UIAlertController(title: "Error", message: displayMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func loginUserIntoApp(_ sender: Any) {
        if (self.txt_email.text?.isEmpty)! || (self.txt_password.text?.isEmpty)! {
            self.showAlert(displayMessage:"Please enter all the fields to proceed further...");
        } else {
            
            Auth.auth().signIn(withEmail: self.txt_email.text!, password: self.txt_password.text!) { (user, error) in
                if error == nil {
                    print("You have successfully logged in")
                    UserDefaults.standard.set(user?.uid, forKey: "Current_User_ID")
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(user?.uid, forKey: "Current_User_ID")
                        self.performSegue(withIdentifier: "segue_to_notebooks", sender: nil)
                    }
                } else {
                    self.showAlert(displayMessage:(error?.localizedDescription)!);
                }
            }
        }
    }
   
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        if let svc = segue.source as? RegisterViewController{
           
        }
        if let svc = segue.source as? NotebooksViewController{
            try! Auth.auth().signOut();
            self.txt_email.text = "";
            self.txt_password.text = "";
            UserDefaults.standard.removeObject(forKey: "Current_User_ID")
        }
    }
    
}
