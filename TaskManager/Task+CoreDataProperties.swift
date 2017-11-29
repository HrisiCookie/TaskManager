//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by Hristina Bailova on 29.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completionDate: String?
    @NSManaged public var isTaskCompleted: Bool
    @NSManaged public var taskTitle: String?
    @NSManaged public var category: Category?

}
