//
//  AddNewTaskViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit
import CoreData

class AddNewTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameTextField.delegate = self
        dateTextField.delegate = self
    }
  
    
    @IBAction func didPressAddTaskBtn(_ sender: Any) {
        // Pass data in Core Data Task Model
        guard let taskName = taskNameTextField.text,
            let date = dateTextField.text else {return}
        
        if !taskName.isEmpty && !date.isEmpty {
            self.save { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Empty fields!", message: "All fields should be filled in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // save to Core Data
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let task = Task(context: managedContext) // to know where to store data
        
        task.taskTitle = taskNameTextField.text
        task.completionDate = dateTextField.text
        
        do {
            try managedContext.save()
            print("Successfully saved data!")
            completion(true)
        } catch {
            print("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
}
