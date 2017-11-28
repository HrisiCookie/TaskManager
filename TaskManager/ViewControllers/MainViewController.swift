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
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.isHidden = true
        
        self.tableView.register(UINib(nibName:"\(TaskCell.self)", bundle: nil), forCellReuseIdentifier: "\(TaskCell.self)")
    }
    
    // actions
    @IBAction func pressedAddTaskButton(_ sender: Any) {
        print("Pressed add task")
    }
    @IBAction func pressedSettingsButton(_ sender: Any) {
        print("Pressed settings")
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: "\(TaskCell.self)", for: indexPath) as? TaskCell else {return UITableViewCell()}
        
        taskCell.configCell(taskTitle: "New task title", completionDate: "23.12.2017")
        
        return taskCell
    }
}
