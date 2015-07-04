//
//  Task.swift
//  count
//
//  Created by Zhiheng Yi on 2015-07-04.
//  Copyright (c) 2015 Zhiheng Yi. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {
    @NSManaged var content: String
    @NSManaged var count: Int16
}