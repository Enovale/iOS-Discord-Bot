//
//  FirstViewController.swift
//  SwordBot
//
//  Created by Elijah on 9/11/18.
//  Copyright © 2018 Elijah. All rights reserved.
//

import UIKit
import Sword
import AVFoundation
import MediaPlayer

struct Logs {
    static var logs = ""
}

struct Token {
    static var token = ""
}

struct Bot {
    static var bot: Sword? = nil
    static var shield: Shield? = nil
}

struct Settings {
    static var musicOn = true
    static var notificationsOn = true
    static var chatLog = false
}

class FirstViewController: UIViewController {
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var log = ""
    var task = BackgroundTask()
    var audioPlayer: AVAudioPlayer?
    var isAudioPlayerPlaying = false
    var view2 = SecondViewController()
    var botStarted = false
    var token = ""
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    var videoYTLink = "http://www.youtube.com/watch?v=PT2_F-1esPk";
    
    var converterLink = "www.youtubeinmp3.com/fetch/?format=text&video=";
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func play(_ sender: AnyObject) {
        player.play()
    }
    
    @IBAction func pause(_ sender: AnyObject) {
        player.pause()
    }
    
    @IBAction func replay(_ sender: AnyObject) {
        //Replay Logic
        player.currentTime = 0;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBot()
        do {
            // Offline Code:
            let audioPath = Bundle.main.path(forResource: "song", ofType: "mp3")
            
            try player = AVAudioPlayer(contentsOf: NSURL (fileURLWithPath: audioPath!)as URL);
            player.numberOfLoops = -1
        }
        catch {
            // Error
            print("Error getting the audio file")
        }
        
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch{
            
        }
    }
    
    func initBot() {
        if let filepath = Bundle.main.path(forResource: "token", ofType: "txt") {
            do {
                token = try String(contentsOfFile: filepath).replacingOccurrences(of: "\n", with: "")
                print(token)
            } catch {
                // contents could not be loaded
                print("Couldn't load token")
            }
        } else {
            // example.txt not found!
            print("token file not found")
        }
        Bot.bot = Sword(token: token)
        Bot.shield = Shield(token: token)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartButton(_ sender: Any) {
        //registerBackgroundTask()
        //botfunc()
        if(botStarted == true) {
            return
        }
        self.statusLabel.text = "Starting Bot..."
        StartBot()
        if(Settings.musicOn) {
            player.play()
        }
    }
    
    func StartBot() {
        //task.startBackgroundTask()
        print(Token.token)
        Bot.bot?.editStatus(to: "online", playing: "with Sword!")
        
        Bot.bot?.on(.ready) { data in
            self.botStarted = true
            Logs.logs = "Bot Ready\n"
            self.statusLabel.text = "Bot running"
            print("Bot started!")
        }
        
        Bot.bot?.on(.disconnect) { data in
            Logs.logs += "\nBot shut down."
            self.statusLabel.text = "Bot offline"
            self.botStarted = false
        }
        
        Bot.bot?.on(.messageCreate) { data in
            let msg = data as! Message
            
            if(msg.content.hasPrefix("!") || msg.author?.id == Bot.bot?.user?.id || Settings.chatLog == true) {
                Logs.logs += (msg.author?.username)! + ": " + msg.content + "\n"
            }
            
            if msg.content == "!ping" {
                msg.reply(with: "Pong!")
            }
        }
        
        Bot.shield?.register("yeet") { msg, args in
            if(args[0] != "") {
                msg.reply(with: args[0] + "got yeeted by: " + (msg.author?.username)!)
            }
        }
        
        Bot.bot?.connect()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func deselectField(_ sender: UITextField) {
        sender.resignFirstResponder()
        Bot.bot?.editStatus(to: "online", playing: sender.text!)
    }
    
    @IBAction func changedPlay(_ sender: UITextField) {
        Logs.logs += "Changed play status to " + sender.text! + "\n"
        Bot.bot?.editStatus(to: "online", playing: sender.text!)
    }
    
    @IBAction func StopButton(_ sender: UIButton) {
        if(botStarted == false) {
            return
        }
        Bot.bot?.disconnect()
        Logs.logs += "\nBot shut down.\n"
        self.statusLabel.text = "Bot offline"
        self.botStarted = false
    }
    
    
}
