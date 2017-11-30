//
//  SettingsViewController.swift
//  TaskManager
//
//  Created by Hristina Bailova on 30.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    @IBOutlet weak var notificationsSwitch: UISwitch!
    let defaults: UserDefaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined, .denied:
                self.defaults.set(false, forKey: UserDefaultsKeys.notificationsStatus)
            case .authorized:
                self.defaults.set(true, forKey: UserDefaultsKeys.notificationsStatus)
            }
            
            print("Switch state: \(self.defaults.bool(forKey: UserDefaultsKeys.notificationsStatus))")
            DispatchQueue.main.async {
                self.notificationsSwitch.isOn = self.defaults.bool(forKey: UserDefaultsKeys.notificationsStatus)
            }
        }
    }
    
    @IBAction func switchButtonChanged(_ sender: Any) {
        if notificationsSwitch.isOn {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (notificationSettings) in
                switch notificationSettings.authorizationStatus {
                case .notDetermined, .denied:
                    self.requsetNotificationAler()
                case .authorized:
                    print("Notification")
                    self.defaults.set(true, forKey: UserDefaultsKeys.notificationsStatus)
                }
            })
        } else {
            defaults.set(false, forKey: UserDefaultsKeys.notificationsStatus)
            
            // the other option to turn off the local notifications is to
            // navigate the user to the app settings, so he can turn them off
            
//            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
//                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//            }
        }
    }
    
    func requsetNotificationAlert() {
        let alert = UIAlertController(title: AlertMessages.requestNotificationsTitle, message: AlertMessages.requestNotificationsMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AlertMessages.cancelBtn, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: AlertMessages.settingsBtn, style: .default) { (_) in
            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString),
                UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }
}
