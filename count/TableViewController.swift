//
//  TableViewController.swift
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
class TableViewController: UITableViewController {
    
    let fetchRequest = NSFetchRequest(entityName:"Task")
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var tasks = [Task]()
    
    override func viewWillAppear(animated: Bool) {
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tasks.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("task", forIndexPath: indexPath) as! TableViewCell
        cell.addButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: "addTapped:", forControlEvents: .TouchUpInside)
        cell.minusButton.addTarget(self, action: "minusTapped:", forControlEvents: .TouchUpInside)
        cell.content = tasks[indexPath.row].content
        cell.count = Int(tasks[indexPath.row].count)
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    


    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            println("delete at \(indexPath.row)")
            deleteTaskAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        changeIndex(tasks[fromIndexPath.row], task2: tasks[toIndexPath.row])
        tableView.reloadData()

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
        let medium = task1.count
        task1.count = task2.count
        task2.count = medium
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

}
