//
//  Home.swift
//  GasAlert
//
//  Created by Davis Booth on 12/17/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import UIKit

class Home: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout?
    
    var deals: [String] = [String]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor(red:0.47, green:0.25, blue:0.02, alpha:1.0)
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView!.refreshControl = refresher
        
        
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:#imageLiteral(resourceName: "GasAlert"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        self.collectionView.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        
        
        self.layout = UICollectionViewFlowLayout()
        self.layout!.minimumInteritemSpacing = 25
        self.layout!.minimumLineSpacing = 25
        self.layout!.sectionInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        
        
        self.layout!.itemSize = CGSize(width: self.view.frame.width-30, height: 265)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        self.collectionView.collectionViewLayout = layout!
        
        // Fetch deals
        Server.database.sharedRef.child("Deals").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? [String : Any] ?? [String : Any]()
            self.deals = Array(value.keys)
        }
        
        self.tabBarController!.tabBar.barTintColor = UIColor(red:0.86, green:0.44, blue:0.24, alpha:1.0)
        self.navigationController!.navigationBar.barTintColor = UIColor(red:0.86, green:0.44, blue:0.24, alpha:1.0)
        
    }
    
    @objc func loadData() {
        // do nothing
        self.collectionView!.refreshControl?.beginRefreshing()
        self.collectionView!.refreshControl?.endRefreshing()
    }
    

}



// Table View Delegate
extension Home {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-30, height: 265)
    }
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  return CGSize(width: self.view.frame.width-30, height: 265)
    //}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.fullInit(self.deals[indexPath.item])
        
        return cell
        
    }
    
    
}
