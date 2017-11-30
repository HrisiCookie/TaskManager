//
//  Constants.swift
//  TaskManager
//
//  Created by Hristina Bailova on 30.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation

struct ButtonTitles {
    static let deleteBtn = "DELETE"
    static let chooseColorBtn = "Choose color"
    static let addTask = "Add task"
}

struct AlertMessages {
    static let savedTitle = "Saved!"
    static let savedMessage = "Your changes are saved."
    static let okBtn = "OK"
    static let cancelBtn = "Cancel"
    static let deleteTitle = "Do you want to delete the task?"
    static let deleteMessage = "If you delete the current task, the data will disappear"
    static let emptyFieldsTitle = "Empty fields!"
    static let emptyFieldsMessage = "All fields should be filled in."
}

struct UserDefaultsKeys {
    static let notificationsStatus = "notificationsStatus"
}
