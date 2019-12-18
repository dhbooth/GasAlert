//
//  Map.swift
//  GasAlert
//
//  Created by Davis Booth on 12/18/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import UIKit
import GoogleMaps


class Map: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var deals : [String]? {
        didSet {
            self.addPins()
        }
    }
    
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 36.00777, longitude: -78.92648, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 36.00777, longitude: -78.92648)
        print("POS ", marker.position)
        marker.icon = #imageLiteral(resourceName: "fire")
        marker.title = "Guasaca"
        marker.snippet = "25 Percent Off Any Order"
        marker.map = mapView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 33.99045, longitude: -80.97575)
        print("POS ", marker.position)
        marker2.icon = #imageLiteral(resourceName: "fire")
        marker2.title = "Buffalo Wild Wings"
        marker2.snippet = "Free Nachos"
        marker2.map = mapView
        
        
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2D(latitude: 33.99894, longitude: -81.01676)
        print("POS ", marker.position)
        marker3.icon = #imageLiteral(resourceName: "fire")
        marker3.title = "Insomnia Cookies"
        marker3.snippet = "50% Off Delivery"
        marker3.map = mapView
        
        
        
        
        
        let url = Bundle.main.url(forResource: "gmap-style", withExtension: "json")
        do {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: url!)
        }
        catch {
            print("Failed to load one or more map styles")
        }
        
        Server.database.sharedRef.child("Deals").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? [String : Any] ?? [String : Any]()
            
            var temp: [String] = [String]()
            for key in value.keys {
                temp.append(key)
            }
            self.deals = temp
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor(red:0.86, green:0.44, blue:0.24, alpha:1.0)
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:#imageLiteral(resourceName: "GasAlert"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    
    func addPins() {
        // Creates a marker in the center of the map.
        for deal in self.deals ?? [String]() {
            var dealProper = Deal(dealID: deal, parentMap: self)
        }
        
    }
    
    
    

}
