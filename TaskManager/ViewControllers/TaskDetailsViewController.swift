//
//  TaskDetailsViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

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
    @IBOutlet weak var taskNameTextView: UITextView!
    
    var coreDataManager: CoreDataManager = CoreDataManager()
    let notificationsManager: NotificationsManager = NotificationsManager()
    var typeViewController: TypeViewController = .detailsViewController
    var taskDetails: Task?
    
    var colorToString: String = ""
    var date: String?
    
    var buttonTypeTitle: ButtonState = .edit
    let btn1 = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameTextView.delegate = self
        self.hideKeyboardWhenTapped()
        
        colourView.layer.borderWidth = 2
        colourView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        colourView.makeViewCircle()
        
        if typeViewController == .detailsViewController {
            setupRightBarButtonItem()
            if let categoryColor = taskDetails?.category?.colour {
                colourView.backgroundColor = UIColor.returnUIColor(components: categoryColor)
            }
            //        } else {
            //            colourView.backgroundColor = .white
            //        }
            
            taskNameTextView.text = taskDetails?.taskTitle
            dateTextField.text = taskDetails?.completionDate
            categoryTextField.text = taskDetails?.category?.name
        } else {
            colourView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            changeColorBtn.setTitle(ButtonTitles.chooseColorBtn, for: .normal)
            addOrDeleteBtn.setTitle(ButtonTitles.addTask, for: .normal)
            userInteraction(isEnabled: true)
        }
    }
    
    //private methods
    private func userInteraction(isEnabled: Bool) {
        taskNameTextView.isUserInteractionEnabled = isEnabled
        categoryTextField.isUserInteractionEnabled = isEnabled
        changeColorBtn.isUserInteractionEnabled = isEnabled
        datePicker.isUserInteractionEnabled = isEnabled
    }
    
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
            self.userInteraction(isEnabled: true)
            buttonTypeTitle = .save
            btn1.setTitle(buttonTypeTitle.rawValue, for: .normal)
        case .save:
            print("Save pressed")
            
            guard let taskNameText = taskNameTextView.text,
                taskNameTextView.text != "Next task?",
                let dateText = dateTextField.text,
                let categoryText = categoryTextField.text,
                let backgroundColor = colourView.backgroundColor,
                let taskDetails = taskDetails else {return}
            
            if !taskNameText.isEmpty && !dateText.isEmpty {
                if date == nil {
                    getDate()
                }
                self.coreDataManager.saveChanges(taskDetails: taskDetails, taskName: taskNameText, categoryName: categoryText, categoryColor: backgroundColor, date: date!) { (complete) in
                    if complete {
                        self.createAlert(title: AlertMessages.savedTitle, message: AlertMessages.savedMessage, actionTitles: [AlertMessages.okBtn], actions: [{ (_) in }])
                    }
                }
            }
        }
    }
    
    private func deleteCurrentTask() {
        self.createAlert(title: AlertMessages.deleteTitle, message: AlertMessages.deleteMessage, actionTitles: [AlertMessages.cancelBtn, AlertMessages.okBtn], actions: [{ (_) in }, { (okAction) in
            self.coreDataManager.deleteTask(taskDetails: self.taskDetails!)
            self.navigationController?.popViewController(animated: true)
            }])
    }
    
    private func addNewTask() {
        guard let taskName = taskNameTextView.text,
            taskNameTextView.text != "Next task?",
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
                    self.notificationsManager.createLocalNotifications()
                }
            }
        } else {
            self.createAlert(title: AlertMessages.emptyFieldsTitle, message: AlertMessages.emptyFieldsMessage, actionTitles: [AlertMessages.okBtn], actions: [{ (_) in }])
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func getDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        date = strDate
        UserDefaults.standard.set(date, forKey: "lastDate")
        dateTextField.text = strDate
    }
    
    // actions
    @IBAction func didPressDeleteTaskBtn(_ sender: Any) {
        switch typeViewController {
        case .detailsViewController:
            deleteCurrentTask()
        case .addTaskViewController:
            addNewTask()
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

extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        taskNameTextView.text = ""
        taskNameTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

extension TaskDetailsViewController: ChooseColorDelegate {
    func didChooseColor(color: UIColor) {
        self.colourView.backgroundColor = color
    }
}
