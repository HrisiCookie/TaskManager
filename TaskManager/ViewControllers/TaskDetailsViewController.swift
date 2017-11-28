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
    
    @IBOutlet weak var taskNameTextFields: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var taskDetails: Task?
    var buttonTypeTitle: ButtonState = .edit
    
    let btn1 = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn1.setTitle(buttonTypeTitle.rawValue, for: .normal)
        btn1.setTitleColor(.black, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn1.addTarget(self, action: #selector(editDetails), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    
        taskNameTextFields.text = taskDetails?.taskTitle
        dateTextField.text = taskDetails?.completionDate
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @objc func editDetails() {
        switch buttonTypeTitle {
        case .edit:
            print("Edit pressed")
            taskNameTextFields.isUserInteractionEnabled = true
            dateTextField.isUserInteractionEnabled = true
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
    
    func saveChanges(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}

        taskDetails?.taskTitle = taskNameTextFields.text
        taskDetails?.completionDate = dateTextField.text
        
        do {
            try managedContext.save()
            print("Successfully updated data!")
            completion(true)
        } catch {
            print("Could not update: \(error.localizedDescription)")
            completion(false)
        }
    }
}
