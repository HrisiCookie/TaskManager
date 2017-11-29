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
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var colorToString: String = ""
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameTextField.delegate = self
        dateTextField.delegate = self
        
        colorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @IBAction func didPressAddTaskBtn(_ sender: Any) {
        // Pass data in Core Data Task Model
        guard let taskName = taskNameTextField.text,
            let category = categoryNameTextField.text
        else {return}
        
        if !taskName.isEmpty && !category.isEmpty {
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
        let category = Category(context: managedContext)
        
        if date == nil {
            getDate()
        }
        
        if let colorToSave = colorView.backgroundColor {
            colorToString = UIColor.stringFromUIColor(color: colorToSave)
        }
        
        task.taskTitle = taskNameTextField.text
        task.completionDate = date
        category.colour = colorToString
        category.name = categoryNameTextField.text
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
    
    // private methods
    private func getDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        date = strDate
        dateTextField.text = strDate
    }
    
    @IBAction func didPressChooseColorBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chooseColourVC = storyboard.instantiateViewController(withIdentifier: "\(ChooseColorViewController.self)") as? ChooseColorViewController else {return}
            chooseColourVC.delegate = self
        navigationController?.pushViewController(chooseColourVC, animated: true)
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        getDate() 
    }
    
}

extension AddNewTaskViewController: ChooseColorDelegate {
    func didChooseColor(color: UIColor) {
        self.colorView.backgroundColor = color
    }
}
