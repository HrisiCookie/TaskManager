//
//  TaskDetailsViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailsViewController: UIViewController {
    
    enum TypeViewController {
        case detailsViewController
        case addTaskViewController
    }
    
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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addOrDeleteBtn: UIButton!
    
    var coreDataManager: CoreDataManager = CoreDataManager()
    var typeViewController: TypeViewController = .detailsViewController
    var taskDetails: Task?
    
    var colorToString: String = ""
    var date: String?
    
    var buttonTypeTitle: ButtonState = .edit
    let btn1 = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if typeViewController == .detailsViewController {
            setupRightBarButtonItem()
            if let categoryColor = taskDetails?.category?.colour {
                colourView.backgroundColor = UIColor.returnUIColor(components: categoryColor)
            }
            //        } else {
            //            colourView.backgroundColor = .white
            //        }
            
            taskNameTextFields.text = taskDetails?.taskTitle
            dateTextField.text = taskDetails?.completionDate
            categoryTextField.text = taskDetails?.category?.name
        } else {
            colourView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            changeColorBtn.setTitle("Choose color", for: .normal)
            addOrDeleteBtn.setTitle("Add task", for: .normal)
            
            taskNameTextFields.isUserInteractionEnabled = true
            categoryTextField.isUserInteractionEnabled = true
            changeColorBtn.isUserInteractionEnabled = true
        }
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
            categoryTextField.isUserInteractionEnabled = true
            buttonTypeTitle = .save
            btn1.setTitle(buttonTypeTitle.rawValue, for: .normal)
        case .save:
            print("Save pressed")
            
            guard let taskNameText = taskNameTextFields.text,
                let dateText = dateTextField.text,
                let categoryText = categoryTextField.text,
                let backgroundColor = colourView.backgroundColor,
                let taskDetails = taskDetails else {return}
            
            if !taskNameText.isEmpty && !dateText.isEmpty {
                self.coreDataManager.saveChanges(taskDetails: taskDetails, taskName: taskNameText, categoryName: categoryText, categoryColor: backgroundColor, date: date!) { (complete) in
                    if complete {
                        let alert = UIAlertController(title: "Saved!", message: "Your changes are saved.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    private func getDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        date = strDate
        dateTextField.text = strDate
    }
    
    // actions
    @IBAction func didPressDeleteTaskBtn(_ sender: Any) {
        switch typeViewController {
        case .detailsViewController:
            let alert = UIAlertController(title: "Do you want to delete the task?", message: "If you delete the current task, the data will disappear", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.coreDataManager.deleteTask(taskDetails: self.taskDetails!)
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        case .addTaskViewController:
            guard let taskName = taskNameTextFields.text,
                let category = categoryTextField.text,
                let backgroundColor = colourView.backgroundColor
                else {return}
            
            if date == nil {
                getDate()
            }
            
            if !taskName.isEmpty && !category.isEmpty {
                self.coreDataManager.save(backgroundColor: backgroundColor, date: date!, categoryName: category, taskName: taskName) { (complete) in
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
    }
    
    @IBAction func didPressChooseColourBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chooseColourVC = storyboard.instantiateViewController(withIdentifier: "\(ChooseColorViewController.self)") as? ChooseColorViewController else {return}
        chooseColourVC.delegate = self
        navigationController?.pushViewController(chooseColourVC, animated: true)
    }
    
    @IBAction func didPressDatePicker(_ sender: Any) {
        getDate()
    }
    
}

extension TaskDetailsViewController: ChooseColorDelegate {
    func didChooseColor(color: UIColor) {
        self.colourView.backgroundColor = color
    }
}

