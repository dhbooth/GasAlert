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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 3

    }
}
