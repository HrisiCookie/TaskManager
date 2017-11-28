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
        // Do any additional setup after loading the view.
    }
  
    
    @IBAction func didPressAddTaskBtn(_ sender: Any) {
        // Pass data in Core Data Task Model
        
        if !(taskNameTextField.text?.isEmpty)! && !(dateTextField.text?.isEmpty)! {
            self.save { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
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
