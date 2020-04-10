//
//  PopupView.swift
//  GasAlert
//
//  Created by Davis Booth on 12/18/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import UIKit

class PopupView: UIViewController {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var priceRateGasLabel: UILabel!
    @IBOutlet weak var useDealButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    static var myDeal: Deal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        PopupView.myDeal?.addObserver()
        populateDeal()
        setupDealAesthetic()
        
        useDealButton.layer.cornerRadius = 7
    }
    
    deinit {
        print("Removed Observers")
        PopupView.myDeal?.removeObserver()
    }
    
    func populateDeal() {
        self.dealLabel.text = PopupView.myDeal?.name ?? ""
        self.restaurantLabel.text = PopupView.myDeal?.restaurantOfferedBy?.name ?? ""
        
        let price = PopupView.myDeal?.restaurantOfferedBy?.price_rating ?? 0
        var priceStr = ""
        
        // TODO:: Make this real!!
        //for i in 0..<price {
        for i in 0..<2 {
            priceStr += "$"
        }
        
        // TODO:: Make this real!!
        let rate = PopupView.myDeal?.restaurantOfferedBy?.user_rating ?? 5.0
        let rateStr = "5/5"
        //let rateStr = String(rate) + "/5"
        
        var gas = PopupView.myDeal?.myLikes?.count ?? 0
        let gasStr = String(gas)
        
        self.priceRateGasLabel.text = "Price: " + priceStr + "  |  " + "Rate: " + rateStr + "  |  " + "Gas: " + gasStr
        Server.fileStore.getDownloadURLAndDownloadAndCache(Server.fileStore.sharedRef.child("Restaurants").child(PopupView.myDeal!.restaurantOfferedBy!.id!), imageView: self.imageView)
        
//        // Gas rate.
//        if gas > 4 {
//            fire1.image = #imageLiteral(resourceName: "fireSmall")
//            fire2.image = #imageLiteral(resourceName: "fireSmall")
//            fire3.image = #imageLiteral(resourceName: "fireSmall")
//            fire4.image = #imageLiteral(resourceName: "fireSmall")
//        }
//        else if gas > 3 {
//            fire1.image = #imageLiteral(resourceName: "fireSmall")
//            fire2.image = #imageLiteral(resourceName: "fireSmall")
//            fire3.image = #imageLiteral(resourceName: "fireSmall")
//            fire4.image = #imageLiteral(resourceName: "unfire")
//        }
//        else if gas > 2 {
//            fire1.image = #imageLiteral(resourceName: "fireSmall")
//            fire2.image = #imageLiteral(resourceName: "fireSmall")
//            fire3.image = #imageLiteral(resourceName: "unfire")
//            fire4.image = #imageLiteral(resourceName: "unfire")
//        }
//        else {
//            fire1.image = #imageLiteral(resourceName: "fireSmall")
//            fire2.image = #imageLiteral(resourceName: "unfire")
//            fire3.image = #imageLiteral(resourceName: "unfire")
//            fire4.image = #imageLiteral(resourceName: "unfire")
//        }
        
    }
    
    func setupDealAesthetic(hasJoined: Bool?=nil) {
        if (PopupView.myDeal?.myUsers?.contains(Server.auth.currentLocalUser!.id!) ?? false) || !(hasJoined ?? true) {
            self.useDealButton.backgroundColor = UIColor.clear
            self.useDealButton.setTitleColor(Style.trademark_orange, for: .normal)
            
            var rawUID = UUID().uuidString.uppercased()
            let formattedUID = String(rawUID.popLast()!) + String(rawUID.popLast()!) + String(rawUID.popLast()!) + "-" + String(rawUID.popLast()!) + String(rawUID.popLast()!) + String(rawUID.popLast()!)
            
            if PopupView.myDeal?.restaurantOfferedBy != nil {
                Server.database.sharedRef.child("Restaurants").child(PopupView.myDeal!.restaurantOfferedBy!.id!).child("pendingRedemption").child(formattedUID).setValue("pending")
            }
            
            self.useDealButton.setTitle("CONFIRMATION: " + formattedUID, for: .normal)
            
            
            self.useDealButton.isEnabled = false
            
        }
        else {
            self.useDealButton.backgroundColor = Style.trademark_orange
            self.useDealButton.setTitleColor(UIColor.white, for: .normal)
            self.useDealButton.setTitle("USE DEAL", for: .normal)
            self.useDealButton.isEnabled = true
        }
    }
    
    
    @IBAction func useDealButton(_ sender: Any) {
        if PopupView.myDeal?.myUsers?.contains(Server.auth.currentLocalUser!.id!) ?? false {
            print("you already used me headass")
        }
        else {
            PopupView.myDeal?.myRef?.child("users").child(Server.auth.currentLocalUser!.id!).setValue("used")
            setupDealAesthetic(hasJoined: false)
        }
    }
}
