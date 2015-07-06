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
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let fetchRequest = NSFetchRequest(entityName:"Task")
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    var tasks = [Task]()
    
    
    override func viewWillAppear(animated: Bool) {
        refresh()
    }
    override func viewDidLoad() {
        
        newTaskButton.layer.shadowOffset = CGSizeMake(3, 3)
        newTaskButton.layer.shadowRadius = 3
        newTaskButton.layer.shadowColor = UIColor.grayColor().CGColor
        newTaskButton.layer.shadowOpacity = 0.5
        
        
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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
        changeIndex(tasks[fromIndexPath.row], task2: tasks[toIndexPath.row])
        refresh()
        tableView.reloadData()
        
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    func addTapped (sender: UIButton) {
        updateStoredItem(tasks[sender.tag], flag: Flag.add)
        self.tableView.reloadData()
    }
    func minusTapped (sender: UIButton) {
        updateStoredItem(tasks[sender.tag], flag: Flag.minus)
        self.tableView.reloadData()
    }
    
    func updateStoredItem (task: Task, flag: Flag) {
        switch flag {
        case .add: task.count += 1
        case .minus:
            if task.count == 0 {
                task.count = 0
            } else {
                task.count -= 1
            }
        default: ()
        }
        save()
    }
    
    func changeIndex (task1: Task, task2: Task) {
        let medium = task1.index
        task1.index = task2.index
        task2.index = medium
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
    func save () {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    @IBAction func newTaskButtonTapped(sender: UIButton) {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Enter Text", message: "Enter some text below", preferredStyle: .Alert)
        alertController!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter something"
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

