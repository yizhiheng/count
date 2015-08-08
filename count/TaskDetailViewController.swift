//
//  TaskDetailViewController.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-06.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.

import UIKit
class TaskDetailViewController: UIViewController {

    @IBOutlet weak var taskIcon: SpringImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var countLabel: SpringLabel!
    @IBOutlet weak var contentLabel: SpringLabel!
    @IBOutlet weak var startingNumberLabel: SpringLabel!
    @IBOutlet weak var stepDistanceLabel: SpringLabel!
    @IBOutlet weak var startingNumberIndicateLabel: SpringLabel!
    @IBOutlet weak var colorBarView: UIView!
    @IBOutlet weak var secondContentLabel: SpringLabel!
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var settingStatusView: UIView!
    @IBOutlet weak var nameStatusView: UIView!
    @IBOutlet weak var startingStatusView: UIView!
    @IBOutlet weak var stepStatusView: UIView!
    @IBOutlet weak var iconStatusView: UIView!
    
    @IBOutlet weak var maskButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var statusViewHeight: NSLayoutConstraint!
    
    var scrollViewHeight: CGFloat! = 300.0

    var taskIndex: Int? {
        didSet {
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modifyLayout()
        
        let nameViewTap = UITapGestureRecognizer(target: self, action: "nameViewTapped:")
        nameStatusView.addGestureRecognizer(nameViewTap)
        let startingViewTap = UITapGestureRecognizer(target: self, action: "startingViewTapped:")
        startingStatusView.addGestureRecognizer(startingViewTap)
        let stepViewTap = UITapGestureRecognizer(target: self, action: "stepViewTapped:")
        stepStatusView.addGestureRecognizer(stepViewTap)
        let iconViewTap = UITapGestureRecognizer(target: self, action: "iconViewTapped:")
        iconStatusView.addGestureRecognizer(iconViewTap)
        
        settingStatusView.layer.addSublayer(upperBorder(settingStatusView))
        let statusViews = [nameStatusView, startingStatusView, stepStatusView, iconStatusView]
        for view in statusViews {
            view.backgroundColor = UIColor.whiteColor()
            view.layer.addSublayer(upperBorder(view))
        }
        
        minusButton.backgroundColor = UIColor.clearColor()
        minusButton.layer.cornerRadius = 25
        minusButton.layer.borderWidth = 0.3
        minusButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        addButton.backgroundColor = UIColor.clearColor()
        addButton.layer.cornerRadius = 25
        addButton.layer.borderWidth = 0.3
        addButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        animateSwing(countLabel, contentLabel)
        showData()
        setScrollView()
        
        
    }
    
    func modifyLayout () {
        countLabel.adjustsFontSizeToFitWidth = true
        if DeviceType.IS_IPHONE_4 {
            statusViewHeight.constant = 45.0
        } else if DeviceType.IS_IPHONE_5 {
            statusViewHeight.constant = 50.0
        } else {
          statusViewHeight.constant = 60.0
        }
        scrollViewHeight = statusViewHeight.constant * 5
        self.scrollView.transform = CGAffineTransformMakeTranslation(0, scrollViewHeight)
        
    }
    
    func showData () {
        colorBarView.backgroundColor = bgColors[Int(tasks[tappedTaskIndex].bgColor)]
        countLabel.text = "\(tasks[tappedTaskIndex].count)"
        contentLabel.text = "\(tasks[tappedTaskIndex].content)..."
        secondContentLabel.text = "\(tasks[tappedTaskIndex].content)"
        startingNumberLabel.text = "\(tasks[tappedTaskIndex].startingNumber)"
        stepDistanceLabel.text = "\(tasks[tappedTaskIndex].stepDistance)"
        taskIcon.image = UIImage(named: tasks[tappedTaskIndex].icon)
    }
    func setScrollView () {
        
        let iconNameArray =  ["shop", "anchor", "booklet", "caution", "cruise", "gamecontroller", "hourglass", "paintroller", "rainbow", "spaceshuttle", "tractor", "art", "briefcase", "chat", "denied", "gas", "lightbulb", "parachute", "recycle", "stack", "travelerbag", "bike", "brightness", "check", "fashion", "hazard", "megaphone2", "phone", "ribbon", "star", "ufo", "blimp", "browser", "compass", "flame", "heart", "merge", "plane", "rocket", "submarine", "unlocked", "bolt", "car", "compose", "flash", "helicopter", "microphone", "present", "running", "support", "windy", "bomb", "cart", "countdown", "flower", "hotair", "motorcycle", "racingflags", "tools", "x"]

        scrollView.pagingEnabled = true
        scrollView.bounces = true
        scrollView.clipsToBounds = false
        scrollView.contentSize = CGSizeMake(2 * view.frame.size.width, scrollView.frame.size.height)
        
        
        let viewWidth = view.frame.size.width
        let viewHeight = scrollView.frame.size.height
        let buttonLength: CGFloat = 50
        let verticalPadding = (viewHeight - 4 * buttonLength) / 5
        let horizontalPadding = (viewWidth - 4 * buttonLength) / 5
        
        var verticalPosition = verticalPadding
        var horizontalPosition = horizontalPadding
        
        for index in 0...16 {
            let button = UIButton(frame: CGRectMake(horizontalPosition, verticalPosition, buttonLength, buttonLength))
            button.setImage(UIImage(named: iconNameArray[index]), forState: UIControlState.Normal)
            let name = iconNameArray[index]
            button.restorationIdentifier = name
            button.addTarget(self, action: "iconButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            scrollView.addSubview(button)
            
            if index == 3 || index == 7 || index == 11 {
                horizontalPosition = horizontalPadding
                verticalPosition += buttonLength + verticalPadding
            } else if index == 15 {
                horizontalPosition += buttonLength + 2 * horizontalPadding
                verticalPosition = verticalPadding
            } else {
                horizontalPosition += buttonLength + horizontalPadding
            }
            
        }

    }
    func iconButtonTapped (sender: UIButton) {
        let imageName = sender.restorationIdentifier!
        tasks[tappedTaskIndex].icon = imageName
        save()
        taskIcon.image = UIImage(named: imageName)
        taskIcon.animation = "squeezeUp"
        taskIcon.curve = "spring"
        taskIcon.duration = 0.8
        taskIcon.animate()
        hideScrollView()
    }
    
    func nameViewTapped (sender: AnyObject) {
        let alert = SCLAlertView()
        let nameTextField = alert.addTextField(title:"new task name...")
        alert.addButton("Submit") {
            alert.isGoingToDismiss = true
            var stateChanged = false
            if nameTextField.text != "" {
                tasks[tappedTaskIndex].content = nameTextField.text
                stateChanged = true
            } else {
                alert.isGoingToDismiss = false
                alert.viewText.text = "Oops! Task name cannot be empty. Please try again."
                alert.viewText.textColor = UIColor.redColor()
                alert.viewText.animation = "shake"
                alert.viewText.curve = "spring"
                alert.viewText.duration = 1.0
                alert.viewText.animate()
            }
            if stateChanged {
                save()
                self.showData()
            }
        }
        alert.showEdit("Change Task Name...", subTitle:"What is the new name of this task?")
        
    }
    func startingViewTapped (sender: AnyObject) {
        let alert = SCLAlertView()
        let startingNumber = alert.addTextField(title:"new starting number...")
        startingNumber.keyboardType = UIKeyboardType.NumberPad
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
            if stateChanged {
                save()
                self.showData()
            }
        }
        alert.showEdit("Change starting #...", subTitle:"What is the new starting # of this task? Old record will be earsed")
    }
    func stepViewTapped (sender: AnyObject) {
        let alert = SCLAlertView()
        let stepDistance = alert.addTextField(title:"new step distance...")
        stepDistance.keyboardType = UIKeyboardType.NumberPad
        alert.addButton("Submit") {
            alert.isGoingToDismiss = true
            var stateChanged = false
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
        alert.showEdit("Change step distance...", subTitle:"What is the new step distance of this task?")
    }
    
    func iconViewTapped (sender: AnyObject) {
        showMask()
        scrollView.hidden = false
        scrollView.transform = CGAffineTransformMakeTranslation(0, 300)
        spring(0.5) {
            self.scrollView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.mainContentView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        }
    }
    
    func showMask() {
        self.maskButton.hidden = false
        self.maskButton.alpha = 0
        spring(0.5) {
            self.maskButton.alpha = 1
        }
    }
    
    func hideScrollView() {
        spring(0.5) {
            self.maskButton.alpha = 0
            self.scrollView.transform = CGAffineTransformMakeTranslation(0, self.scrollViewHeight)
            self.mainContentView.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
    
    // MARK: - IBActions
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
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        println("\(tappedTaskIndex)")
        deleteTaskAtIndex(tappedTaskIndex)
        self.performSegueWithIdentifier("unwindToMain", sender: self)
    }
    @IBAction func maskButtonTapped(sender: AnyObject) {
        hideScrollView()
    }
    

}