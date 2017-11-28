//
//  MainViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class MainViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(UINib(nibName:"\(TaskCell.self)", bundle: nil), forCellReuseIdentifier: "\(TaskCell.self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetch { (complete) in
            if complete {
                if tasks.count < 1 {
                    tableView.isHidden = true
                } else {
                    tableView.isHidden = false
                }
            }
        }
        tableView.reloadData()
    }
    
    // actions
    @IBAction func pressedAddTaskButton(_ sender: Any) {
        print("Pressed add task")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNewTaskVC = storyboard.instantiateViewController(withIdentifier: "\(AddNewTaskViewController.self)") as? AddNewTaskViewController else {return}
        navigationController?.pushViewController(addNewTaskVC, animated: true)
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
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: "\(TaskCell.self)", for: indexPath) as? TaskCell else {return UITableViewCell()}
        let currentTask = tasks[indexPath.row]
        
//        taskCell.configCell(taskTitle: "New task title", completionDate: "23.12.2017")
        taskCell.configCell(taskTitle: currentTask.taskTitle!, completionDate: currentTask.completionDate!)
        
        return taskCell
    }
}

extension MainViewController {
    // fetch all tasks data and save it in array
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        // fetch request - grab data from persistant storage
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        // fetch items that are in this entity
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        do {
            tasks = try managedContext.fetch(fetchRequest)
            print("Tasks array: \(tasks.count)")
            print("Successfully fatched data!")
            completion(true)
        } catch {
            print("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}
