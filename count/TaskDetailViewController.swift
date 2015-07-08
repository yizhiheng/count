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
    
    @IBOutlet weak var countLabel: SpringLabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var startingNumberLabel: UILabel!
    @IBOutlet weak var stepDistanceLabel: UILabel!
    
    var taskIndex: Int? {
        didSet {
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //self.navigationController.navigationBar.barStyle = UIBarStyleBlack
        //
        minusButton.backgroundColor = UIColor.clearColor()
        minusButton.layer.cornerRadius = 20
        minusButton.layer.borderWidth = 0.3
        minusButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        addButton.backgroundColor = UIColor.clearColor()
        addButton.layer.cornerRadius = 20
        addButton.layer.borderWidth = 0.3
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        println(tappedTaskIndex)

        
        showData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func showData () {
        countLabel.text = "\(tasks[tappedTaskIndex].count)"
        contentLabel.text = "\(tasks[tappedTaskIndex].content)..."
        startingNumberLabel.text = "\(tasks[tappedTaskIndex].startingNumber)"
        stepDistanceLabel.text = "\(tasks[tappedTaskIndex].stepDistance)"
    }
    
    
    
    @IBAction func addTapped(sender: UIButton) {
        updateStoredItem(tasks[tappedTaskIndex], Flag.add)
        countLabel.animation = "pop"
        countLabel.duration = 0.5
        countLabel.animate()
        showData()
    }
    @IBAction func minusTapped(sender: UIButton) {
        updateStoredItem(tasks[tappedTaskIndex], Flag.minus)
        showData()
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
