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
    @IBOutlet weak var restaurantOwnerButton: UIButton!
    
    var isRestaurantOwner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signupButton.layer.cornerRadius = 7
        self.restaurantOwnerButton.layer.cornerRadius = 7
        self.restaurantOwnerButton.layer.borderColor = UIColor.lightGray.cgColor
        self.restaurantOwnerButton.layer.borderWidth = 1
    }
    
    @IBAction func restaurantOwnerButton(_ sender: Any) {
        // Aes.
        if self.isRestaurantOwner {
            self.restaurantOwnerButton.layer.borderColor = UIColor.lightGray.cgColor
            self.restaurantOwnerButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
        else {
            self.restaurantOwnerButton.layer.borderColor = Style.trademark_orange.cgColor
            self.restaurantOwnerButton.setTitleColor(Style.trademark_orange, for: .normal)
        }
        
        // State.
        self.isRestaurantOwner = !self.isRestaurantOwner
        
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
                   
                    if self.isRestaurantOwner {
                        Server.database.sharedRef.child("Users").child(auth!.user.uid).child("entityType").setValue("Restaurant")
                        self.performSegue(withIdentifier: "toRestaurantHome", sender: self)
                    }
                    else {
                        Server.database.sharedRef.child("Users").child(auth!.user.uid).child("entityType").setValue("Customer")
                        self.performSegue(withIdentifier: "toHome", sender: self)
                    }
                    
                }
                else {
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
