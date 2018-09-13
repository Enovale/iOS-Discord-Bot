//
//  SettingsViewController.swift
//  SwordBot
//
//  Created by Elijah on 9/12/18.
//  Copyright © 2018 Elijah. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBAction func toggleMusic(_ sender: UISwitch) {
        Settings.musicOn = sender.isOn
    }
    
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        Settings.notificationsOn = sender.isOn
    }
    
    @IBAction func toggleChatLog(_ sender: UISwitch) {
        Settings.chatLog = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
