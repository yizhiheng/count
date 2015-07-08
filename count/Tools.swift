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
    
    
    func addShadow(buttons: UIButton...) {
        for button in buttons {
            button.layer.shadowOffset = CGSizeMake(3, 3)
            button.layer.shadowRadius = 3
            button.layer.shadowColor = UIColor.grayColor().CGColor
            button.layer.shadowOpacity = 0.5
        }
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


func updateStoredItem (task: Task, flag: Flag) {
    switch flag {
    case .add: task.count += task.stepDistance
    case .minus:
        task.count -= task.stepDistance
        if task.count < 0 {
            task.count = 0
        }
    default: ()
    }
    save()
}

func save () {
    var error: NSError?
    if !managedObjectContext.save(&error) {
        println("Could not save \(error), \(error?.userInfo)")
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

