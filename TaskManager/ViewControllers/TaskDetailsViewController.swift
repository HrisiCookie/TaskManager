//
//  TaskDetailsViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    @IBOutlet weak var taskNameTextFields: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var taskDetails: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        taskNameTextFields.text = taskDetails?.taskTitle
        dateTextField.text = taskDetails?.completionDate
        // Do any additional setup after loading the view.
    }

}
