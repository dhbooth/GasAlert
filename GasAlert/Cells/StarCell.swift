//
//  StarCell.swift
//  GasAlert
//
//  Created by Davis Booth on 12/17/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import UIKit

class StarCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func fullInit(_ isStarred: Bool) {
        if isStarred {
            self.image.image = #imageLiteral(resourceName: "star")
        }
        else {
            self.image.image = #imageLiteral(resourceName: "unstar").withRenderingMode(.alwaysTemplate)
            self.image.tintColor = UIColor.white
        }
    }
    

}
