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
    static var isRest = false
    
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
        
        // Permissions.
        if (Server.auth.currentLocalUser?.isRestaurant ?? false) || Home.isRest {
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(createDeal))
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = Style.background_orange
        }
        else {
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem()
        }
        
        self.collectionView.backgroundColor = UIColor.white
        
        
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
        if (Server.auth.currentLocalUser?.isRestaurant ?? false) || Home.isRest {    // For Restaurant.
            Server.database.sharedRef.child("Restaurants").child(Server.auth.currentLocalUser!.id!).child("deals").observe(.value, with: { (snapshot) in
                let value = snapshot.value as? [String : Any] ?? [String : Any]()
                self.deals = Array(value.keys)
            })
        }
        else {      // For User.
            Server.database.sharedRef.child("Deals").observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? [String : Any] ?? [String : Any]()
                var temp = Array(value.keys)
                temp.sort { (deal1, deal2) -> Bool in
                    let s1 = (value[deal1] as! [String : Any])["startDate"] as! String
                    let s2 = (value[deal2] as! [String : Any])["startDate"] as! String
                    return s1 < s2
                }
                self.deals = temp
                
            }
        }
        
        // Orangify.
    
        // self.tabBarController!.tabBar.barTintColor = UIColor(red:0.86, green:0.44, blue:0.24, alpha:1.0)
        // self.navigationController!.navigationBar.barTintColor = UIColor(red:0.86, green:0.44, blue:0.24, alpha:1.0)
        
    }
    
    @objc func createDeal() {
        self.performSegue(withIdentifier: "toCreateDeal", sender: self)
    }
    
    
    
    @IBAction func signout(_ sender: Any) {
        try! Server.auth.sharedRef.signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signIn")
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func loadData() {
        // do nothing
        self.collectionView!.refreshControl?.beginRefreshing()
        self.collectionView!.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toDetail" {
            let dest = segue.destination as! PopupView
            
        }
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
        PopupView.myDeal = Deal(dealID: self.deals[indexPath.item], completion: {
            self.performSegue(withIdentifier: "toDetail", sender: self)
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.fullInit(self.deals[indexPath.item], homePage: self)
        
        return cell
        
    }
    
    
}
