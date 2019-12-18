//
//  Map.swift
//  GasAlert
//
//  Created by Davis Booth on 12/18/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import UIKit

class Map: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor(red:0.86, green:0.44, blue:0.24, alpha:1.0)
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:#imageLiteral(resourceName: "GasAlert"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        
        
    }

}
