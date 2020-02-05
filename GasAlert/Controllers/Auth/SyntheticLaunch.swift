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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Signed in?
        if let signInUser = Auth.auth().currentUser {
            signin(true, userID: signInUser.uid)
        }
        else {
            signin(false)
        }
    }
    
    func signin(_ shouldAuto: Bool, userID: String?=nil) {
        if shouldAuto {
            UIView.animate(withDuration: 1.0, animations: {
                self.view.backgroundColor = Style.background_orange
            }) { (b) in
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
            
        }
        else {
            self.performSegue(withIdentifier: "toLogin", sender: self)
        }
    }
    
    
    

}
