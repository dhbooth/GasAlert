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
    
    var parent: Home?
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
        
        //self.gasButton.tintColor = UIColor.lightGray.withAlphaComponent(0.6)
        
        
        if Server.auth.currentLocalUser!.isRestaurant ?? false {
            let long = UILongPressGestureRecognizer(target: self, action: #selector(deletePost))
            long.minimumPressDuration = 1
            self.addGestureRecognizer(long)
        }
        
    }
    
    @objc func deletePost() {
        let alert = UIAlertController(title: "Delete Deal?", message: "Are you sure you want to delete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (a1) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (a2) in
            self.confirmedDelete()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        // Present
        parent?.present(alert, animated: true, completion: nil)
        
        
    }
    
    func confirmedDelete() {
        
        // Remove Local.
        self.parent?.deals.removeAll(where: { (d) -> Bool in
            return d == self.myDeal!.id!
        })
        self.parent?.collectionView.reloadData()
        
        // Remove From Rest.
        Server.database.sharedRef.child("Restaurants").child(Server.auth.currentLocalUser!.id!).child(self.myDeal!.id!).removeValue()
        
        // Remove Global.
        Server.database.sharedRef.child("Deals").child(self.myDeal!.id!).removeValue()
    }
    
    @IBAction func gasButton(_ sender: Any) {
        if self.myDeal!.myLikes?.contains(Server.auth.currentLocalUser!.id!) ?? false {
            Server.database.sharedRef.child("Deals").child(self.myDeal!.id!).child("likes").child(Server.auth.currentLocalUser!.id!).removeValue()
            self.myDeal!.myLikes?.removeAll(where: { (str) -> Bool in
                return str == Server.auth.currentLocalUser!.id!
            })
            self.numLikes.text = String(self.myDeal?.myLikes?.count ?? 0)
        }
        else {
            Server.database.sharedRef.child("Deals").child(self.myDeal!.id!).child("likes").child(Server.auth.currentLocalUser!.id!).setValue("liked")
            self.myDeal!.myLikes?.append(Server.auth.currentLocalUser!.id!)
            self.numLikes.text = String(self.myDeal?.myLikes?.count ?? 0)
        }
        loadLikes()
        self.pressed = !self.pressed
        
    }
    
    func fullInit(_ dealID: String, homePage: Home) {
        self.parent = homePage
        self.myDeal = Deal(dealID: dealID, parent: self, completion: {
            self.numLikes.text = String(self.myDeal?.myLikes?.count ?? 0)
            self.loadLikes()
            Server.fileStore.getDownloadURLAndDownloadAndCache(Server.fileStore.sharedRef.child("Restaurants").child(self.myDeal!.restaurantOfferedBy!.id!), imageView: self.imageView)
        })
        
        
        
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
        
        // TODO:: Make this real.
        let b = indexPath.item < Int((self.myDeal?.restaurantOfferedBy?.user_rating ?? 0.0))
        cell.fullInit(true)
        //cell.fullInit(b)
        
        return cell
    }
    
}
