//
//  NotificationsManager.swift
//  TaskManager
//
//  Created by Hristina Bailova on 30.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsManager {
    func createLocalNotifications() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.notificationsStatus) == true {
            let content = UNMutableNotificationContent()
            content.title = "New task to complete!"
            content.body = "You successfully added one more task to complete!"
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "taskAdded", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
