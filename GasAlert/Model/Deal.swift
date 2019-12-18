//
//  Deal.swift
//  GasAlert
//
//  Created by Davis Booth on 12/17/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import Foundation
import GoogleMaps



class Deal {
    
    var name: String?
    var discount: Float?
    var restaurantOfferedBy: Restaurant?
    var startDate: String?
    var endDate: String?
    var parent: HomeCell?
    
    init(dealID: String, parent: HomeCell? = nil, parentMap: Map? = nil)  {
        Server.database.sharedRef.child("Deals").child(dealID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? [String:Any] ?? [String:Any]()
            
            self.parent = parent
            self.name = value["name"] as? String ?? ""
            self.discount = value["discount"] as? Float ?? 0.0
            self.startDate = value["startDate"] as? String ?? ""
            self.endDate = value["endDate"] as? String ?? ""
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let start = df.date(from: self.startDate!)
            let end = df.date(from: self.endDate!)
            
            df.dateFormat = "MMM d"
            
            parent?.dateRangeLabel.text = df.string(from: start!) + " - " + df.string(from: end!)
            
            
            
            let rest_id = value["restaurantOfferedBy"] as? String ?? ""
            print("REST ID:: ", rest_id)
            self.restaurantOfferedBy = Restaurant(restID: rest_id, completion: {
                if parent != nil {
                    parent?.addressLabel.text = self.restaurantOfferedBy?.address ?? ""
                    parent?.nameLabel.text = (self.restaurantOfferedBy?.name ?? "") + " • " + (self.name ?? "")
                    parent?.ratingCollection.reloadData()
                    Server.fileStore.getDownloadURLAndDownloadAndCache(Server.fileStore.sharedRef.child("RestPics").child(self.restaurantOfferedBy!.name! + ".jpg"), imageView: self.parent?.imageView)
                }
            })
            
        }
    }
    
    
}

