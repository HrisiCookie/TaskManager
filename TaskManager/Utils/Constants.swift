//
//  Constants.swift
//  TaskManager
//
//  Created by Hristina Bailova on 30.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation

struct ButtonTitles {
    static let deleteBtn = "DELETE TASK"
    static let chooseColorBtn = "Choose color"
    static let addTask = "ADD TASK"
}

struct AlertMessages {
    static let savedTitle = "Saved!"
    static let savedMessage = "Your changes are saved."
    static let okBtn = "OK"
    static let cancelBtn = "Cancel"
    static let settingsBtn = "Settings"
    static let deleteTitle = "Do you want to delete the task?"
    static let deleteMessage = "If you delete the current task, the data will disappear"
    static let emptyFieldsTitle = "Empty fields!"
    static let emptyFieldsMessage = "All fields should be filled in."
    static let requestNotificationsTitle = "Do you want to receive notifications?"
    static let requestNotificationsMessage = "If you want to receive notifications, go to Settings."
}

struct Notifications {
    static let title = "New task to complete!"
    static let body = "You successfully added one more task to complete!"
    static let identifier = "taskAdded"
}

struct UserDefaultsKeys {
    static let notificationsStatus = "notificationsStatus"
    static let lastSavedDate = "lastDate"
}

struct TextViewConstants {
    static let placeholder = "Next task?"
}
