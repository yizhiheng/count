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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var normalButtonIs = true
    @IBOutlet weak var editingButton: MenuControl!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        refresh()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController.navigationBar.barStyle = UIBarStyleBlack
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        tableView.emptyDataSetSource = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        newTaskButton.layer.shadowOffset = CGSizeMake(3, 3)
        newTaskButton.layer.shadowRadius = 3
        newTaskButton.layer.shadowColor = UIColor.grayColor().CGColor
        newTaskButton.layer.shadowOpacity = 0.5
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        titleLabel.font = UIFont(name: "Avenir Next", size: 21)
        titleLabel.textAlignment = .Center
        titleLabel.text = "Knots Counter"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = titleLabel

        tableView.separatorStyle = .None
        //tableView.contentMode = UIViewContentMode.ScaleToFill
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        //editingButton.closeAnimation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if (!tableView.editing) {
            // Execute tasks for editing status
            self.tableView.setEditing(true, animated: true)
        } else {
            // Execute tasks for non-editing status.
            self.tableView.setEditing(false, animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("task", forIndexPath: indexPath) as! TableViewCell
        cell.countLabel.tag = indexPath.row
        cell.addButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: "addTapped:", forControlEvents: .TouchUpInside)
        cell.minusButton.addTarget(self, action: "minusTapped:", forControlEvents: .TouchUpInside)
        cell.iconImageView.image = UIImage(named: tasks[indexPath.row].icon)
        cell.content = tasks[indexPath.row].content
        cell.count = Int(tasks[indexPath.row].count)
        cell.backgroundColor = bgColors[Int(tasks[indexPath.row].bgColor)]
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisCell = cell as! TableViewCell
        thisCell.countLabel.animation = "pop"
        thisCell.countLabel.duration = 0.5
        thisCell.countLabel.animate()
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            println("delete at \(indexPath.row)")
            deleteTaskAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            //循环更新加减button的tag
            for var row = 0; row < tableView.numberOfRowsInSection(0); row++ {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! TableViewCell
                cell.addButton.tag = row
                cell.minusButton.tag = row
            }
            
            if tasks.count == 0 {
                //self.tableView.emptyDataSetSource = self
                self.tableView.reloadData()
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //移动了任务的上下顺序
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        changeIndex(fromIndexPath.row, to: toIndexPath.row)
        refresh()
        tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tappedTaskIndex = indexPath.row
        self.performSegueWithIdentifier("showDetailSegue", sender: nil)
    }

    func addTapped (sender: UIButton) {
        if sender.tag < tasks.count {
            updateStoredItem(tasks[sender.tag], Flag.add)
            var indexPath = NSIndexPath(forRow:sender.tag,inSection:0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)


        } else {
            println("error")
        }

    }
    func minusTapped (sender: UIButton) {
        updateStoredItem(tasks[sender.tag], Flag.minus)
        var indexPath = NSIndexPath(forRow:sender.tag,inSection:0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    

    
    func changeIndex (from: Int, to: Int) {
        for task in tasks {
            if from > to {
                if task.index >= Int32(to) && task.index < Int32(from) {
                    task.index++
                }
            }
            if from < to {
                if task.index > Int32(from) && task.index <= Int32(to) {
                    task.index--
                }
                
            }
        }
        tasks[from].index = Int32(to)
        save()
    }
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
            tableView.reloadData()
        } else {
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        let isTableViewNormal = !tableView.editing
        println(isTableViewNormal)
        
        if editingButton.isNormal == isTableViewNormal {
            editingButton.isNormal ? editingButton.closeAnimation() : editingButton.menuAnimation()
            self.tableView.setEditing(!tableView.editing, animated: true)
        } else {
            tableView.editing = isTableViewNormal
        }

    }
    
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

