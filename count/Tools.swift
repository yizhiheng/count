//
//  Tools.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-05.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import Foundation
import UIKit

class Tools {
    
    var colorsForCell = [UIColor]()
    
    func addShadow(buttons: UIButton...) {
        for button in buttons {
            button.layer.shadowOffset = CGSizeMake(3, 3)
            button.layer.shadowRadius = 3
            button.layer.shadowColor = UIColor.grayColor().CGColor
            button.layer.shadowOpacity = 0.5
        }
    }
    
}