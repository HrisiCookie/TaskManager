//
//  TaskCell.swift
//  TaskManager
//
//  Created by Hristina Bailova on 28.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var categoryColor: UIView!
    @IBOutlet weak var taskTitleLable: UILabel!
    @IBOutlet weak var completionDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(taskTitle: String, completionDate: String, colorString: String) {
        taskTitleLable.text = taskTitle
        completionDateLabel.text = completionDate
        categoryColor.backgroundColor = UIColor.returnUIColor(components: colorString)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func didPressCompletedTaskBtn(_ sender: Any) {
    }
}
