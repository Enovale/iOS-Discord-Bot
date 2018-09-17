//
//  SecondViewController.swift
//  SwordBot
//
//  Created by Elijah on 9/11/18.
//  Copyright © 2018 Elijah. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet public weak var LogObject: UITextView!
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UIDevice().type == .iPhoneX) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 0.93, y: 0.93)
        } else if (UIDevice().type == .iPhoneSE) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 0.78, y: 0.78)
        } else if (UIDevice().type == .iPhone8plus) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        } else if (UIDevice().type == .iPhone8) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        } else if (UIDevice().type == .iPhone7plus) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        } else if (UIDevice().type == .iPhone7) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        } else if (UIDevice().type == .iPhone6plus) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        } else if (UIDevice().type == .iPhone6Splus) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        } else if (UIDevice().type == .iPhone6S) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        } else if (UIDevice().type == .iPhone6) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        } else if (UIDevice().type == .iPhone5S) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: 0.77, y: 0.77)
        }
        // Do any additional setup after loading the view, typically from a nib.
        LogObject.text = Logs.logs
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(logUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func logUpdate() {
        self.UpdateLogs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func UpdateLogs() {
        LogObject.text = Logs.logs
        let range = NSMakeRange(LogObject.text.count - 1, 0)
        LogObject.scrollRangeToVisible(range)
    }
    
    @IBAction func UpdateLogs(_ sender: UIButton) {
        UpdateLogs()
    }
    
}

