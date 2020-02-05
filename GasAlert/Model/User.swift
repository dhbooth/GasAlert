//
//  User.swift
//  GasAlert
//
//  Created by Davis Booth on 2/5/20.
//  Copyright © 2020 GasAlert. All rights reserved.
//

import Foundation

class User {

    var id : String?
    var email: String?
    var dealsRedeemed: [String]?

    init(_ userID : String) {
        self.id = userID
        Server.database.sharedRef.child("Users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? [String : Any] ?? [String : Any]()
            self.email = value["email"] as? String ?? ""
            self.dealsRedeemed = value["deals"] as? [String] ?? [String]()
        }
    }
}
