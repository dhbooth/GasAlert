//
//  Signup.swift
//  GasAlert
//
//  Created by Davis Booth on 2/5/20.
//  Copyright © 2020 GasAlert. All rights reserved.
//

import UIKit
import FirebaseAuth

class Signup: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signupButton.layer.cornerRadius = 7

    }
    
    @IBAction func signUpButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (auth, error) in
            if error != nil {
                print(error as! String)
                self.presentFailureAlert()
            }
            else {
                if auth != nil {
                    // Localize.
                    Server.auth.currentLocalUser = User(auth!.user.uid)
                   
                   // Add to DB.
                    Server.database.sharedRef.child("Users").child(auth!.user.uid).child("email").setValue(auth!.user.email!)
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
                else {
                    print("this")
                    self.presentFailureAlert()
                }
            }
        }
    }
    
    func presentFailureAlert() {
        let alert = UIAlertController(title: "Sign Up Error", message: "Invalid email or password too short", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignin", sender: self)
    }

}
