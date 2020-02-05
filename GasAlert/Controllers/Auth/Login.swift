//
//  Login.swift
//  GasAlert
//
//  Created by Davis Booth on 2/5/20.
//  Copyright © 2020 GasAlert. All rights reserved.
//

import UIKit
import FirebaseAuth

class Login: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.layer.cornerRadius = 7
        
        
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        //self.performSegue(withIdentifier: "toForgotPassword", sender: self)
    }
    
    
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (auth, error) in
            if error != nil {
                self.presentFailureAlert()
            }
            else {
                if auth != nil {
                    Server.auth.currentLocalUser = User(auth!.user.uid)
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
                else {
                    self.presentFailureAlert()
                }
            }
        }
    }
    
    func presentFailureAlert() {
        let alert = UIAlertController(title: "Login Error", message: "Either your email or password were incorrect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
    self.performSegue(withIdentifier: "toSignup", sender: self)
    }

}
