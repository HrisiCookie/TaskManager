//
//  CoreDataManager.swift
//  TaskManager
//
//  Created by Hristina Bailova on 29.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    func saveChanges(taskDetails: Task, taskName: String, categoryName: String, categoryColor: UIColor, date: String, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        taskDetails.taskTitle = taskName
        taskDetails.completionDate = date
        taskDetails.category?.name = categoryName
        taskDetails.category?.colour = UIColor.stringFromUIColor(color: categoryColor)
        
        do {
            try managedContext.save()
            print("Successfully updated data!")
            completion(true)
        } catch {
            print("Could not update: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func deleteTask(taskDetails: Task) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        managedContext.delete(taskDetails)
        print("Deleted task")
            
        do {
            try managedContext.save()
            print("Successfully removed task!")
        } catch {
            print("Could not remove: \(error.localizedDescription)")
        }
    }
    
    // save to Core Data
    func save(backgroundColor: UIColor, date: String, categoryName: String, taskName: String, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let task = Task(context: managedContext) // to know where to store data
        let category = Category(context: managedContext)
        
        task.taskTitle = taskName
        task.completionDate = date
        category.colour = UIColor.stringFromUIColor(color: backgroundColor)
        category.name = categoryName
        task.category = category
        
        do {
            try managedContext.save()
            print("Task: \(task)")
            print("Successfully saved data!")
            completion(true)
        } catch {
            print("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
}
