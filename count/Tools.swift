//
//  Tools.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-05.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import Foundation
import UIKit

var slala = "123"


class Tools {
    
    
    func addShadow(buttons: UIButton...) {
        for button in buttons {
            button.layer.shadowOffset = CGSizeMake(3, 3)
            button.layer.shadowRadius = 3
            button.layer.shadowColor = UIColor.grayColor().CGColor
            button.layer.shadowOpacity = 0.5
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func colorsForCell () -> [UIColor] {
        let colors = [
            UIColor(red: 247, green: 216, blue: 101),
            UIColor(red: 94, green: 195, blue: 184),
            UIColor(red: 244, green: 123, blue: 106),
            UIColor(red: 209, green: 220, blue: 224),
        ]

        return colors
    }
}

func addShadow(objects: AnyObject...) {
    for object in objects {
        object.layer.shadowOffset = CGSizeMake(3, 3)
        object.layer.shadowRadius = 3
        object.layer.shadowColor = UIColor.grayColor().CGColor
        object.layer.shadowOpacity = 0.5
    }
}

private extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

