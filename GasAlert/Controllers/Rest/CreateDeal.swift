//
//  CreateDeal.swift
//  GasAlert
//
//  Created by Davis Booth on 4/10/20.
//  Copyright © 2020 GasAlert. All rights reserved.
//

import UIKit

class CreateDeal: UIViewController {

    @IBOutlet weak var dealNameTF: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButton.layer.cornerRadius = 7
    }
    
    
    func displayAlert() {
        let alert = UIAlertController(title: "Invalid Info", message: "Be sure to add a deal name, give a start date, and an end date that is after the start date!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alert1) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func createButton(_ sender: Any) {
        if startDate.date < endDate.date && dealNameTF.text != nil && dealNameTF.text != "" {
            
            let deal_id = UUID().uuidString
            let info = [ "name" : dealNameTF.text!,
                         "discount" : 0.0,
                         "restaurantOfferedBy" : Server.auth.currentLocalUser!.id!,
                         "startDate" : startDate.date.description,
                         "endDate" : endDate.date.description
                ] as [String : Any]
           
            // Create Deal.
            Server.database.sharedRef.child("Deals").child(deal_id).setValue(info)
            
            // Link to Rest.
            Server.database.sharedRef.child("Restaurants").child(Server.auth.currentLocalUser!.id!).child("deals").child(deal_id).setValue("Deal")
        
            // Dismiss.
            self.dismiss(animated: true, completion: nil)
        }
        else {
            displayAlert()
        }
    }
    
}
