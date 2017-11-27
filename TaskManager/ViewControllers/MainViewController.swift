//
//  MainViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        
    }
    
    // actions
    @IBAction func pressedAddTaskButton(_ sender: Any) {
        print("Pressed add task")
    }
    @IBAction func pressedSettingsButton(_ sender: Any) {
        print("Pressed settings")
    }
}
