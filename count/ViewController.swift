//
//  ViewController.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-04.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.

import UIKit
import CoreData

enum Flag {
    case add
    case minus
}
let fetchRequest = NSFetchRequest(entityName:"Task")
let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
var tasks = [Task]()
var tappedTaskIndex: Int = 0

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
    var normalButtonIs = true

    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var taskCollectionView: UICollectionView!

    
    deinit {
        self.taskCollectionView.emptyDataSetSource = nil
        self.taskCollectionView.emptyDataSetDelegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.view.backgroundColor = UIColor.clearColor()
//        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        refresh()
        taskCollectionView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController.navigationBar.barStyle = UIBarStyleBlack
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        taskCollectionView.emptyDataSetSource = self
        
        taskCollectionView.dataSource = self
        taskCollectionView.delegate = self
        

    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        newTaskButton.layer.shadowOffset = CGSizeMake(3, 3)
        newTaskButton.layer.shadowRadius = 3
        newTaskButton.layer.shadowColor = UIColor.grayColor().CGColor
        newTaskButton.layer.shadowOpacity = 0.5
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        titleLabel.font = UIFont(name: "Avenir Next", size: 21)
        titleLabel.textAlignment = .Center
        titleLabel.text = "KnotsCounter"
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = titleLabel

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TaskCell", forIndexPath: indexPath) as! TaskCell
        cell.countLabel.tag = indexPath.row
        cell.addButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: "addTapped:", forControlEvents: .TouchUpInside)
        cell.minusButton.addTarget(self, action: "minusTapped:", forControlEvents: .TouchUpInside)
        cell.iconImageView.image = UIImage(named: tasks[indexPath.row].icon)
        cell.content = tasks[indexPath.row].content
        cell.count = Int(tasks[indexPath.row].count)
        cell.colorBar.backgroundColor = bgColors[Int(tasks[indexPath.row].bgColor)]
        cell.updateUI()
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        tappedTaskIndex = indexPath.row
        self.performSegueWithIdentifier("showDetailSegue", sender: nil)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let thisCell = cell as! TaskCell
        thisCell.popCountLabel()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellHeight = 60
        return CGSizeMake(taskCollectionView.bounds.size.width - 10.0, CGFloat(cellHeight))
    }


    func addTapped (sender: UIButton) {

        if sender.tag < tasks.count {
            updateStoredItem(tasks[sender.tag], Flag.add)
            var indexPath = NSIndexPath(forRow:sender.tag,inSection:0)
            let cell = taskCollectionView.cellForItemAtIndexPath(indexPath) as! TaskCell
            cell.count = Int(tasks[sender.tag].count)
            cell.popCountLabel()
        } else {
            println("error")
        }

    }
    func minusTapped (sender: UIButton) {
        if sender.tag < tasks.count {
            updateStoredItem(tasks[sender.tag], Flag.minus)
            var indexPath = NSIndexPath(forRow:sender.tag,inSection:0)
            let cell = taskCollectionView.cellForItemAtIndexPath(indexPath) as! TaskCell
            cell.count = Int(tasks[sender.tag].count)
            cell.popCountLabel()
        } else {
            println("error")
        }
    }
    

    
    func addNewTask (content: String) {
        let entity =  NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
        let task = Task(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        task.index = Int32(tasks.count)
        task.content = content
        task.count = Int32(0)
        task.startingNumber = Int32(0)
        task.stepDistance = Int32(1)
        task.icon = "shop"    //default icon
        
        //给任务赋值颜色
        if let lastTask = tasks.last {
            let lastBgColor = lastTask.bgColor
            if Int(lastBgColor) >= bgColors.count - 1 {
                task.bgColor = 0
            } else {
                task.bgColor = lastBgColor + 1
            }
        }
        save()
        tasks.append(task)
        var row = tasks.count - 1
        var indexPath = NSIndexPath(forRow: row, inSection: 0)
        if tasks.count == 1 {
            //tableView.reloadData()
            taskCollectionView.reloadData()
        } else {
            //tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            taskCollectionView.insertItemsAtIndexPaths([indexPath])
        }
    }
    
    func refresh () -> Bool {
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        tasks = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Task]
        if error == nil {
            return true
        } else {
            println("error")
            return false
        }
    }
    
    // MARK: - IBActions

    @IBAction func newTaskButtonTapped(sender: UIButton) {
        
        let alert = SCLAlertView()
        let txt = alert.addTextField(title:"simple words to describe me...")
        alert.addButton("Submit") {
            alert.isGoingToDismiss = true
            if txt.text != "" {
                self.addNewTask(txt.text)
                //alert.state = true
            } else {
                
                alert.isGoingToDismiss = false
                alert.viewText.text = "Oops! Something goes wrong. Please try again."
                alert.viewText.textColor = UIColor.redColor()
                alert.viewText.animation = "shake"
                alert.viewText.curve = "spring"
                alert.viewText.duration = 1.0
                alert.viewText.animate()
            }
        }
        alert.showEdit("New task...", subTitle:"What kind of thing you want to record today?")
    }
}

// MARK: - 主ViewController Extension
extension ViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        
        if let img = UIImage(named: "emptySet"){
            return img
        }
        return nil
        
    }
}

