//
//  HomeCell.swift
//  GasAlert
//
//  Created by Davis Booth on 12/17/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceRatingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingCollection: UICollectionView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var gasButton: UIButton!
    @IBOutlet weak var numLikes: UILabel!
    
    var layout: UICollectionViewFlowLayout?
    
    var myDeal: Deal?
    
    var pressed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layout = UICollectionViewFlowLayout()
        self.layout!.minimumInteritemSpacing = 5
        self.layout!.minimumLineSpacing = 5
        self.layout!.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        self.layout!.itemSize = CGSize(width: 20, height: 20)
        
        self.ratingCollection.delegate = self
        self.ratingCollection.dataSource = self
        self.ratingCollection.register(UINib(nibName: "StarCell", bundle: nil), forCellWithReuseIdentifier: "StarCell")
        self.ratingCollection.collectionViewLayout = layout!
        
        self.gasButton.tintColor = UIColor.lightGray.withAlphaComponent(0.6)
    }
    
    @IBAction func gasButton(_ sender: Any) {
        if pressed {
            Server.database.sharedRef.child(self.myDeal!.id!).child("likes").child(Server.auth.currentLocalUser!.id!).removeValue()
        }
        else {
            Server.database.sharedRef.child(self.myDeal!.id!).child("likes").child(Server.auth.currentLocalUser!.id!).setValue("liked")
        }
        self.pressed = !self.pressed
        
    }
    
    func fullInit(_ dealID: String) {
        self.myDeal = Deal(dealID: dealID, parent: self, completion: {
            
        })
        self.numLikes.text = String(Int.random(in: 0..<98))
    }
    
    func loadLikes() {
        if self.myDeal!.myLikes?.contains(Server.auth.currentLocalUser!.id!) ?? false {
            self.numLikes.textColor = UIColor(red:0.86, green:0.44, blue:0.24, alpha:1.0)
            self.gasButton.setImage(#imageLiteral(resourceName: "fire"), for: .normal)
        }
        else {
            self.numLikes.textColor = UIColor(red:0.55, green:0.47, blue:0.37, alpha:1.0)
            self.gasButton.setImage(#imageLiteral(resourceName: "unfire"), for: .normal)
        }
    }

}


// Collection View Delegate
extension HomeCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.ratingCollection.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as! StarCell
        
        print("rating:: ", self.myDeal?.restaurantOfferedBy?.user_rating)
        let b = indexPath.item < Int((self.myDeal?.restaurantOfferedBy?.user_rating ?? 0.0))
        cell.fullInit(b)
        
        return cell
    }
    
}
