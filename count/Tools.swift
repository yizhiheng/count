//
//  Tools.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-05.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import Foundation
import UIKit

let bgColors: [UIColor] = [
    UIColor(red: 247, green: 216, blue: 101),
    UIColor(red: 94, green: 195, blue: 184),
    UIColor(red: 244, green: 123, blue: 106),
    UIColor(red: 209, green: 220, blue: 224),
]

func deleteTaskAtIndex (index: Int) {
    managedObjectContext.deleteObject(tasks[index])
    tasks.removeAtIndex(index)
    for task in tasks {
        if task.index > Int32(index) {
            task.index -= 1
        }
    }
    save()
}

func upperBorder (view: UIView) -> CALayer {
    let upperBorder = CALayer()
    upperBorder.backgroundColor = UIColor.lightGrayColor().CGColor
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 0.3)
    return upperBorder
}
func updateStoredItem (task: Task, flag: Flag) {
    
    //Bug: 需要加一个计算范围判断
    
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

func fitInt32 (text: String) -> Bool {
    if text.toInt() != nil {
        let intNum = text.toInt()
        if intNum >= 0 && intNum <= 999999999 {
            return true
        }
    }
    return false
}

func animateSwing(objects: SpringLabel...) {
    for object in objects {
        object.animation = "swing"
        object.curve = "spring"
        object.duration = 0.8
        object.animate()
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

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}


