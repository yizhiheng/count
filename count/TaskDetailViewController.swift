//
//  TaskDetailViewController.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-06.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.view.backgroundColor = UIColor.clearColor()
//        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        //self.navigationController.navigationBar.barStyle = UIBarStyleBlack
        //
        minusButton.backgroundColor = UIColor.clearColor()
        minusButton.layer.cornerRadius = 8
        minusButton.layer.borderWidth = 0.3
        minusButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        addButton.backgroundColor = UIColor.clearColor()
        addButton.layer.cornerRadius = 8
        addButton.layer.borderWidth = 0.3
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
