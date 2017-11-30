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
            content.title = Notifications.title
            content.body = Notifications.body
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: Notifications.identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
