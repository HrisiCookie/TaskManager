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
        
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
       
        tableView.reloadData()
    }
    
    // private methods
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(UINib(nibName:"\(TaskCell.self)", bundle: nil), forCellReuseIdentifier: "\(TaskCell.self)")
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView()
    }
    
    private func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                tableView.isHidden = tasks.count < 1 ? true : false
            }
        }
    }
    
    // actions
    @IBAction func pressedAddTaskButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNewTaskVC = storyboard.instantiateViewController(withIdentifier: "\(TaskDetailsViewController.self)") as? TaskDetailsViewController else {return}
        addNewTaskVC.typeViewController = .addTaskViewController
        navigationController?.pushViewController(addNewTaskVC, animated: true)
    }
    
    @IBAction func pressedSettingsButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingsVC = storyboard.instantiateViewController(withIdentifier: "\(SettingsViewController.self)") as? SettingsViewController else {return}
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
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
        
        let backgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if tasks[indexPath.row].category?.colour != nil {
            taskCell.backgroundColor = UIColor.returnUIColor(components: (tasks[indexPath.row].category?.colour)!)
        } else {
            taskCell.backgroundColor = backgroundColor
        }
        taskCell.configCell(taskTitle: currentTask.taskTitle!, completionDate: currentTask.completionDate!)
        
        return taskCell
    }
    
    // enable swipe, delete, edit cells in tableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    //create editing actions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: ButtonTitles.deleteBtn) { (rowAction, indexPath) in
            self.removeTask(atIndexPath: indexPath)
            // the data is changed, so we need to fetch it again
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let taskDetailsVC = storyboard.instantiateViewController(withIdentifier: "\(TaskDetailsViewController.self)") as? TaskDetailsViewController else {return}
        taskDetailsVC.typeViewController = .detailsViewController
        taskDetailsVC.taskDetails = tasks[indexPath.row]
        navigationController?.pushViewController(taskDetailsVC, animated: true)
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
    
    // remove objects from Core Data
    func removeTask(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        managedContext.delete(tasks[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfully removed task!")
        } catch {
            print("Could not remove: \(error.localizedDescription)")
        }
    }
}
