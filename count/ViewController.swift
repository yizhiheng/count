//
//  ViewController.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-04.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import UIKit
import CoreData

enum Flag {
    case add
    case minus
}

let fetchRequest = NSFetchRequest(entityName:"Task")
let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

var tasks = [Task]() {
didSet {
    
}
}
var tappedTaskIndex: Int = 0

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        refresh()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        
        //self.navigationController.navigationBar.barStyle = UIBarStyleBlack
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        
        newTaskButton.layer.shadowOffset = CGSizeMake(3, 3)
        newTaskButton.layer.shadowRadius = 3
        newTaskButton.layer.shadowColor = UIColor.grayColor().CGColor
        newTaskButton.layer.shadowOpacity = 0.5
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        titleLabel.font = UIFont(name: "Avenir Next", size: 23)
        titleLabel.textAlignment = .Center
        titleLabel.text = "Knots"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = titleLabel

        tableView.separatorStyle = .None
        
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tasks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("task", forIndexPath: indexPath) as! TableViewCell
        cell.addButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: "addTapped:", forControlEvents: .TouchUpInside)
        cell.minusButton.addTarget(self, action: "minusTapped:", forControlEvents: .TouchUpInside)
        cell.content = tasks[indexPath.row].content
        cell.count = Int(tasks[indexPath.row].count)
        cell.backgroundColor = Tools().colorsForCell()[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            println("delete at \(indexPath.row)")
            deleteTaskAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        changeIndex(fromIndexPath.row, to: toIndexPath.row)
        refresh()
        tableView.reloadData()
        
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tappedTaskIndex = indexPath.row
        self.performSegueWithIdentifier("showDetailSegue", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        var detailViewController = segue.destinationViewController as! TaskDetailViewController;
//        detailViewController.taskIndex = 10
    }
    
    func addTapped (sender: UIButton) {
        if sender.tag < tasks.count {
            updateStoredItem(tasks[sender.tag], Flag.add)
            self.tableView.reloadData()
        } else {
            println("error")
        }

    }
    func minusTapped (sender: UIButton) {
        updateStoredItem(tasks[sender.tag], Flag.minus)
        self.tableView.reloadData()
    }
    

    
    func changeIndex (from: Int, to: Int) {
        for task in tasks {
            if from > to {
                if task.index >= Int16(to) && task.index < Int16(from) {
                    task.index++
                }
            }
            if from < to {
                if task.index > Int16(from) && task.index <= Int16(to) {
                    task.index--
                }
                
            }
        }
        tasks[from].index = Int16(to)
        save()
    }
    func deleteTaskAtIndex (index: Int) {
        managedObjectContext.deleteObject(tasks[index])
        tasks.removeAtIndex(index)
        for task in tasks {
            if task.index > Int16(index) {
                task.index -= 1
            }
        }
        save()
    }
    func addNewTask (content: String) {
        let entity =  NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
        let task = Task(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        task.index = Int16(tasks.count)
        task.content = content
        task.count = Int16(0)
        task.startingNumber = Int16(0)
        task.stepDistance = Int16(1)
        save()
        refresh()
        tableView.reloadData()
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

    
    
    @IBAction func newTaskButtonTapped(sender: UIButton) {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Tell me more...😃", message: "What kind of thing you want to record today?", preferredStyle: .Alert)
        alertController!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "simple words description..."
        })
        let submitAction = UIAlertAction(title: "Submit",
            style: UIAlertActionStyle.Default,
            handler: {(paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields {
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    if enteredText != "" {
                        self.addNewTask(enteredText)
                    }
                }
            }
        )
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do nothing
        }
        alertController?.addAction(submitAction)
        alertController?.addAction(cancelAction)
        
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
}

