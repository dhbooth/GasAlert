//
//  Restaurant.swift
//  GasAlert
//
//  Created by Davis Booth on 12/17/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import Foundation

class Restaurant {
    
    var name: String?
    var address: String?
    var food_type: String?
    var latitude: Double?
    var longitude: Double?
    var deals: [String]?
    var user_rating: Double?
    var price_rating: Int?
    
    
    init(restID: String, completion:@escaping () -> Void)  {
        Server.database.sharedRef.child("Restaurants").child(restID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? [String : Any] ?? [String : Any]()
            
            self.name = value["name"] as? String ?? ""
            self.address = value["address"] as? String ?? ""
            self.food_type = value["food_type"] as? String ?? ""
            self.latitude = value["latitude"] as? Double ?? 0.0
            self.longitude = value["longitude"] as? Double ?? 0.0
            self.deals = value["deals"] as? [String] ?? [String]()
            self.user_rating = value["user_rating"] as? Double ?? 0.0
            self.price_rating = value["price_rating"] as? Int ?? 0
            completion()
        }
        
        
    }
    
    
    
}

