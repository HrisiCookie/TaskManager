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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationsSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.notificationsStatus)
    }
    
    @IBAction func switchButtonChanged(_ sender: Any) {
        if notificationsSwitch.isOn {
            defaults.set(true, forKey: UserDefaultsKeys.notificationsStatus)
        } else {
            defaults.set(false, forKey: UserDefaultsKeys.notificationsStatus)
            
            // the other option to turn off the local notifications is to
            // navigate the user to the app settings, so he can turn them off
            
//            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
//                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//            }
        }
    }
}
