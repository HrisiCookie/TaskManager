//
//  TaskDetailsViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    enum ButtonState: String {
        case edit = "Edit"
        case save = "Save"
    }
    
    // outlets
    @IBOutlet weak var taskNameTextFields: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var changeColorBtn: UIButton!
    
    var taskDetails: Task?
    var buttonTypeTitle: ButtonState = .edit
    
    let btn1 = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarButtonItem()
        
        if let categoryColor = taskDetails?.category?.colour {
            colourView.backgroundColor = UIColor.returnUIColor(components: categoryColor)
        } else {
            colourView.backgroundColor = .white
        }
    
        taskNameTextFields.text = taskDetails?.taskTitle
        dateTextField.text = taskDetails?.completionDate
        categoryTextField.text = taskDetails?.category?.name
    }
    
    //private methods
    private func setupRightBarButtonItem() {
        btn1.setTitle(buttonTypeTitle.rawValue, for: .normal)
        btn1.setTitleColor(.black, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn1.addTarget(self, action: #selector(editDetails), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }

    @objc private func editDetails() {
        switch buttonTypeTitle {
        case .edit:
            print("Edit pressed")
            taskNameTextFields.isUserInteractionEnabled = true
            dateTextField.isUserInteractionEnabled = true
            changeColorBtn.isUserInteractionEnabled = true
            buttonTypeTitle = .save
            btn1.setTitle(buttonTypeTitle.rawValue, for: .normal)
        case .save:
            print("Save pressed")
            
            if !(taskNameTextFields.text?.isEmpty)! && !(dateTextField.text?.isEmpty)! {
                self.saveChanges { (complete) in
                    if complete {
                        let alert = UIAlertController(title: "Saved!", message: "Your changes are saved.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    private func saveChanges(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}

        taskDetails?.taskTitle = taskNameTextFields.text
        taskDetails?.completionDate = dateTextField.text
        taskDetails?.category?.name = categoryTextField.text
        taskDetails?.category?.colour = UIColor.stringFromUIColor(color: colourView.backgroundColor!)
        
        do {
            try managedContext.save()
            print("Successfully updated data!")
            completion(true)
        } catch {
            print("Could not update: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func deleteTask() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        if let taskDetails = taskDetails {
            managedContext.delete(taskDetails)
            print("Deleted task")
            
            do {
                try managedContext.save()
                print("Successfully removed task!")
            } catch {
                print("Could not remove: \(error.localizedDescription)")
            }
        }
    }
    
    // actions
    @IBAction func didPressDeleteTaskBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Do you want to delete the task?", message: "If you delete the current task, the data will disappear", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.deleteTask()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func didPressChooseColourBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chooseColourVC = storyboard.instantiateViewController(withIdentifier: "\(ChooseColorViewController.self)") as? ChooseColorViewController else {return}
        chooseColourVC.delegate = self
        navigationController?.pushViewController(chooseColourVC, animated: true)
    }
}

extension TaskDetailsViewController: ChooseColorDelegate {
    func didChooseColor(color: UIColor) {
        self.colourView.backgroundColor = color
    }
}

