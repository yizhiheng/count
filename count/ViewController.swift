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
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func viewTapped(sender: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName:"Task")
        var error: NSError?
        tasks = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [Task]
        for task in tasks {

            println("Content: \(task.content)         Count: \(task.count)")
            
        }
        println("----------------------------------")
    }

    @IBAction func addTapped(sender: AnyObject) {
        
        let entity =  NSEntityDescription.entityForName("Task", inManagedObjectContext: managedContext)
        
        let task = Task(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        //task.setValue("read book", forKey: "content")
        task.content = "trytry"
        task.count = 999
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        tasks.append(task)
    }
    
}

