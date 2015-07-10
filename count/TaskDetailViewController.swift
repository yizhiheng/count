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
    
    @IBOutlet weak var startingNumberIndicateLabel: UILabel!
    
    var taskIndex: Int? {
        didSet {
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.view.backgroundColor = bgColors[Int(tasks[tappedTaskIndex].bgColor)]

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.adjustsFontSizeToFitWidth = true
        
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
        println("Show Detail of task: \(tappedTaskIndex)")

        
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
        countLabel.animation = "pop"
        countLabel.duration = 0.5
        countLabel.animate()
        showData()
    }

    @IBAction func settingButtonTapped(sender: UIBarButtonItem) {
        let alert = SCLAlertView()
        let startingNumber = alert.addTextField(title:"new starting number...")
        let stepDistance = alert.addTextField(title:"new step distance...")
        startingNumber.keyboardType = UIKeyboardType.NumberPad
        stepDistance.keyboardType = UIKeyboardType.NumberPad
        
        alert.addButton("Submit") {
            alert.isGoingToDismiss = true
            var stateChanged = false
            if startingNumber.text != "" {
                if fitInt32(startingNumber.text) {
                        tasks[tappedTaskIndex].startingNumber = Int32(startingNumber.text.toInt()!)
                        tasks[tappedTaskIndex].count = tasks[tappedTaskIndex].startingNumber
                        stateChanged = true

                } else {
                    alert.isGoingToDismiss = false
                    alert.viewText.text = "Oops! Starting # goes wrong. Please try again."
                    alert.viewText.textColor = UIColor.redColor()
                    alert.viewText.animation = "shake"
                    alert.viewText.curve = "spring"
                    alert.viewText.duration = 1.0
                    alert.viewText.animate()
                }
            }
            
            if stepDistance.text != "" {
                if fitInt32(stepDistance.text) {
                    tasks[tappedTaskIndex].stepDistance = Int32(stepDistance.text.toInt()!)
                    stateChanged = true
                } else {
                    alert.isGoingToDismiss = false
                    alert.viewText.text = "Oops! step distance goes wrong. Please try again."
                    alert.viewText.textColor = UIColor.redColor()
                    alert.viewText.animation = "shake"
                    alert.viewText.curve = "spring"
                    alert.viewText.duration = 1.0
                    alert.viewText.animate()
                }
            
            }
            
            if stateChanged {
                save()
                self.showData()
            }
            
        }
        alert.showEdit("Change numbers...", subTitle:"Which # you want to modify?")
        
    }

}