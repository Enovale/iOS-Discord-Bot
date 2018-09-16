//
//  ChatViewController.swift
//  SwordBot
//
//  Created by Elijah on 9/14/18.
//  Copyright © 2018 Elijah. All rights reserved.
//

import UIKit
import Sword

class ChatViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var serverPicker: UIPickerView!
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBOutlet weak var chatField: UITextField!
    var selectedServer = 0
    var selectedChannel = 0
    var servers: [String] = []
    var channels: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        if(Bot.bot == nil) {
            return
        }
        Bot.guilds?.forEach { servers.append($0.name)}
        var index = 0
        for guild in (Bot.guilds)! {
            if(index == 0) {
                print(guild.name)
                for channel in guild.channels.values {
                    channels.append(channel.name!)
                }
                break
            }
            index = index + 1
        }
        serverPicker.delegate = self
        serverPicker.dataSource = self
        channelPicker.delegate = self
        channelPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            return channels.count
        }else{
            return servers.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if channelPicker!.selectedRow(inComponent: 0) > channels.count {
            channelPicker!.selectRow(channels.count, inComponent: 0, animated: false)
        }
        if (pickerView.tag == 1){
            selectedChannel = channelPicker!.selectedRow(inComponent: 0)
            
            var newrow = row
            if newrow < 0 {
                newrow = 0
            } else if newrow > channels.count {
                newrow = channels.count
            }
            print(newrow)
            return "\(channels[newrow])"
        }else{
            var newchannels: [String] = []
            selectedServer = pickerView.selectedRow(inComponent: 0)
            for guild in (Bot.guilds)! {
                if(guild.name == servers[selectedServer]) {
                    for channel in guild.channels.values {
                        newchannels.append(channel.name!)
                    }
                }
            }
            channels = newchannels
            channelPicker.reloadAllComponents()
            return "\(servers[row])"
        }
    }
    
    @IBAction func chatValueChanged(_ sender: UITextField) {
        /*var textToSend = chatField.text
         var server = Bot.guilds![selectedServer]
         var channellist: [GuildChannel] = []
         for (_,channel) in server.channels {
         channellist.append(channel)
         }
         var channeltosend = channellist[selectedChannel]
         Bot.bot?.setTyping(for: channeltosend.id)*/
    }
    
    @IBAction func deselectChatField(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func sendButton(_ sender: Any) {
        let textToSend = chatField.text
        let server = Bot.guilds![selectedServer]
        var channellist: [GuildChannel] = []
        for (_,channel) in server.channels {
            channellist.append(channel)
        }
        let channeltosend = channellist[selectedChannel]
        Bot.bot?.send(textToSend!, to: channeltosend.id)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
