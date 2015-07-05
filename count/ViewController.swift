//
//  ViewController.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-04.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func viewTapped(sender: AnyObject) {
        refresh()
        for task in tasks {
            println("Index: \(task.index)   Content: \(task.content)    Count: \(task.count)")
        }
        println("----------------------------------")

    }

    @IBAction func addTapped(sender: AnyObject) {
        
        let entity =  NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
        let task = Task(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        task.index = Int16(tasks.count)
        task.content = "test"
        task.count = Int16(arc4random_uniform(10))
        save()
        refresh()

    }
    
    @IBAction func deleteLastTapped(sender: AnyObject) {
        if let last = tasks.last {
            managedObjectContext.deleteObject(tasks.last!)
            save()
            refresh()
        }
    }
    
    func refresh () {
        let fetchRequest = NSFetchRequest(entityName:"Task")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [Task] {
            tasks = fetchResults
        }
    }
    func save () {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
}

