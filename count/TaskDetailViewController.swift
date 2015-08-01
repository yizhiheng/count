//
//  TaskDetailViewController.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-06.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import UIKit
class TaskDetailViewController: UIViewController {

    @IBOutlet weak var taskIcon: SpringImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var countLabel: SpringLabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var startingNumberLabel: UILabel!
    @IBOutlet weak var stepDistanceLabel: UILabel!
    @IBOutlet weak var startingNumberIndicateLabel: UILabel!
    
    @IBOutlet weak var settingStatusView: UIView!
    @IBOutlet weak var nameStatusView: UIView!
    @IBOutlet weak var startingStatusView: UIView!
    @IBOutlet weak var stepStatusView: UIView!
    @IBOutlet weak var iconStatusView: UIView!
   
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    var taskIndex: Int? {
        didSet {
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        //self.view.backgroundColor = bgColors[Int(tasks[tappedTaskIndex].bgColor)]
        self.view.backgroundColor = UIColor.whiteColor()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusViews = [settingStatusView, nameStatusView, startingStatusView, stepStatusView, iconStatusView]
        for view in statusViews {
            view.backgroundColor = UIColor.whiteColor()
            view.layer.addSublayer(upperBorder(view))
        }
        
        settingStatusView.layer.addSublayer(upperBorder(settingStatusView))
        
        countLabel.adjustsFontSizeToFitWidth = true
        
        //self.navigationController.navigationBar.barStyle = UIBarStyleBlack
        //
        minusButton.backgroundColor = UIColor.clearColor()
        minusButton.layer.cornerRadius = 25
        minusButton.layer.borderWidth = 0.3
        minusButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        addButton.backgroundColor = UIColor.clearColor()
        addButton.layer.cornerRadius = 25
        addButton.layer.borderWidth = 0.3
        addButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        println("Show Detail of task: \(tappedTaskIndex)")

        setScrollView()
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
        taskIcon.image = UIImage(named: tasks[tappedTaskIndex].icon)
        
    }
    
    func setScrollView () {
        
        let iconNameArray =  ["shop", "anchor", "booklet", "caution", "cruise", "gamecontroller", "hourglass", "paintroller", "rainbow", "spaceshuttle", "tractor", "art", "briefcase", "chat", "denied", "gas", "lightbulb", "parachute", "recycle", "stack", "travelerbag", "bike", "brightness", "check", "fashion", "hazard", "megaphone2", "phone", "ribbon", "star", "ufo", "blimp", "browser", "compass", "flame", "heart", "merge", "plane", "rocket", "submarine", "unlocked", "bolt", "car", "compose", "flash", "helicopter", "microphone", "present", "running", "support", "windy", "bomb", "cart", "countdown", "flower", "hotair", "motorcycle", "racingflags", "tools", "x"]

        scrollView.pagingEnabled = true
        scrollView.bounces = true
        scrollView.clipsToBounds = true
        
        let buttonLength: CGFloat = 30
        let buttonsCountInPage: CGFloat = 8
        let viewWidth = self.view.frame.width
        var contentLength: CGFloat?
        var buttonPadding: CGFloat = (viewWidth - buttonLength * CGFloat(buttonsCountInPage)) / (buttonsCountInPage + 1)

        let yPosition = scrollView.frame.height / 2 - buttonLength / 2
        var xPosition: CGFloat = 16
        
        for name in iconNameArray {
            
            var newButton = UIButton(frame: CGRectMake(CGFloat(xPosition), yPosition, buttonLength, buttonLength))
            newButton.setImage(UIImage(named: name), forState: UIControlState.Normal)
            newButton.restorationIdentifier = name
            newButton.addTarget(self, action: "iconButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            scrollView.addSubview(newButton)
            xPosition += buttonPadding
            xPosition += buttonLength
        }
        contentLength = xPosition + buttonPadding
        scrollView.contentSize = CGSize(width: contentLength!, height: 40)
        
        
        
    }
    func iconButtonTapped (sender: UIButton) {
        let imageName = sender.restorationIdentifier!
        tasks[tappedTaskIndex].icon = imageName
        save()
        taskIcon.image = UIImage(named: imageName)
        taskIcon.animation = "squeezeUp"
        taskIcon.curve = "spring"
        taskIcon.duration = 1.0
        taskIcon.animate()
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