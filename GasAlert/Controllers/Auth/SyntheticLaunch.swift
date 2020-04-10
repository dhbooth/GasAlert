//
//  SyntheticLaunch.swift
//  GasAlert
//
//  Created by Davis Booth on 2/5/20.
//  Copyright © 2020 GasAlert. All rights reserved.
//

import UIKit
import FirebaseAuth

class SyntheticLaunch: UIViewController {

    
    var isRest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Signed in?
        if let signInUser = Auth.auth().currentUser {
            Server.database.sharedRef.child("Users").child(signInUser.uid).child("entityType").observeSingleEvent(of: .value) { (snapshot) in
                let val = snapshot.value as? String ?? ""
                if val == "Restaurant" {
                    self.isRest = true
                    self.signin(true, isUsr: false, userID: signInUser.uid)
                }
                else {
                    self.signin(true, isUsr: true, userID: signInUser.uid)
                }
            }

        }
        else {
            signin(false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController {
            Home.isRest = self.isRest
        }
    }
    
    func signin(_ shouldAuto: Bool, isUsr: Bool?=true, userID: String?=nil) {
        if shouldAuto {
            UIView.animate(withDuration: 1.0, animations: {
                self.view.backgroundColor = Style.background_orange
            }) { (b) in
                Server.auth.currentLocalUser = User(userID!)
                if isUsr ?? true {
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
                else {
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
            }
            
        }
        else {
            self.performSegue(withIdentifier: "toLogin", sender: self)
        }
    }
    
    
    

}
