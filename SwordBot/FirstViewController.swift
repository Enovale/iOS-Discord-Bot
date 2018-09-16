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
import Dispatch

struct Logs {
    static var logs = ""
}

struct Bot {
    static var bot: Shield? = nil
    static var guilds: [Guild]? = []
    static var guildsAreReady: Bool = false
}

struct Settings {
    static var musicOn = true
    static var notificationsOn = true
    static var chatLog = false
    static var autoStart = false
    static var token = ""
    static var showToken = false
    static var prefix = "!"
}

class FirstViewController: UIViewController {
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var log = ""
    var task = BackgroundTask()
    var audioPlayer: AVAudioPlayer?
    var isAudioPlayerPlaying = false
    var view2 = SecondViewController()
    var botStarted = false
    let defaults = UserDefaults.standard
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    var videoYTLink = "http://www.youtube.com/watch?v=PT2_F-1esPk";
    
    var converterLink = "www.youtubeinmp3.com/fetch/?format=text&video=";
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
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
            let audioPath = Bundle.main.path(forResource: "blank", ofType: "wav")
            
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
        UpdateSettings()
        if Settings.autoStart == true {
            StartBotButton()
        }
    }
    
    func UpdateSettings() {
        var musicBool = defaults.object(forKey:"musicOn") as? Bool
        var notificationsBool = defaults.object(forKey:"notificationsOn") as? Bool
        var chatLogBool = defaults.object(forKey:"chatOn") as? Bool
        var autoStartBool = defaults.object(forKey:"autoStartOn") as? Bool
        var prefixString = defaults.string(forKey: "prefix")
        if musicBool == nil {
            musicBool = Settings.musicOn
        }
        if notificationsBool == nil {
            notificationsBool = Settings.notificationsOn
        }
        if chatLogBool == nil {
            chatLogBool = Settings.chatLog
        }
        if autoStartBool == nil {
            autoStartBool = Settings.autoStart
        }
        if prefixString == nil {
            prefixString = Settings.prefix
        }
        Settings.musicOn = musicBool!
        Settings.notificationsOn = notificationsBool!
        Settings.chatLog = chatLogBool!
        Settings.autoStart = autoStartBool!
        Settings.prefix = prefixString!
    }
    
    func initBot() {
        var settingsToken = ""
        if defaults.string(forKey: "token") != nil {
            settingsToken = defaults.string(forKey: "token")!
        }
        if let filepath = Bundle.main.path(forResource: "token", ofType: "txt") {
            do {
                Settings.token = try String(contentsOfFile: filepath).replacingOccurrences(of: "\n", with: "")
                if settingsToken == "" {
                    defaults.set(Settings.token, forKey: "token")
                }
                print(Settings.token)
            } catch {
                // contents could not be loaded
                print("Couldn't load Settings.token")
            }
        } else {
            // example.txt not found!
            print("token file not found")
            if settingsToken != "" {
                Settings.token = settingsToken
            }
        }
        //Bot.bot = Sword(token: token)
        if (Settings.token == "") {
            let alert = UIAlertController(title: "No token loaded!", message: "The bot can't start until you give it your bot token. Please paste it into Settings.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func StartBotButton() {
        //registerBackgroundTask()
        //botfunc()
        if(botStarted == true) {
            return
        }
        self.statusLabel.text = "Starting Bot..."
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityView.center = self.view.center
        activityView.color? = UIColor.black
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        if (Settings.token == "") {
            let alert = UIAlertController(title: "No token loaded!", message: "The bot can't start until you give it your bot token. Please paste it into Settings.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            self.statusLabel.text = "Bot Offline"
            activityView.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        var shieldOptions = ShieldOptions()
        var swordOptions = SwordOptions()
        shieldOptions.prefixes = [Settings.prefix]
        shieldOptions.willDefaultHelp = true
        swordOptions.isBot = true
        swordOptions.willLog = true
        Bot.bot = Shield(token: Settings.token, with: swordOptions, and: shieldOptions)
        Bot.bot?.getGateway() { [unowned self] data, error in
            if(error != nil) {
                let alert = UIAlertController(title: "Invalid token!", message: "The token you provided is invalid. Please re-paste it in Settings.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
                self.statusLabel.text = "Bot Offline"
                self.activityView.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                return
            } else {
                self.continueInit()
            }
        }
    }
    
    func continueInit() {
        StartBot()
        if(Settings.musicOn) {
            player.play()
        }
    }
    
    @IBAction func StartButton(_ sender: Any) {
        StartBotButton()
    }
    
    func MakeCell(guild: Guild) {
        Bot.guilds?.append(guild)
    }
    
    func StartBot() {
        //task.startBackgroundTask()
        print(Settings.token)
        Bot.bot?.editStatus(to: "online", playing: "with Sword!")
        
        Bot.bot?.on(.ready) { data in
            /*Bot.bot?.getUserGuilds { guilds, error in
             guard error == nil else {
             // You have an error here
             return
             }
             
             guilds!.forEach { self.MakeCell(guild: $0) }
             }*/
            self.guildsAreReady()
        }
        
        /*Bot.bot?.on(.tokenInvalid) { data in
            //stuff
        }*/
        
        Bot.bot?.on(.disconnect) { data in
            Logs.logs += "\nBot shut down."
            self.statusLabel.text = "Bot offline"
            self.botStarted = false
        }
        
        Bot.bot?.on(.messageCreate) { data in
            let msg = data as! Message
            
            if(msg.content.hasPrefix(Settings.prefix) || msg.author?.id == Bot.bot?.user?.id || Settings.chatLog == true) {
                Logs.logs += (msg.author?.username)! + ": " + msg.content + "\n"
            }
        }
        
        var pingOptions = CommandOptions()
        var yeetOptions = CommandOptions()
        yeetOptions.description = "Yeets whatever you want."
        pingOptions.description = "Simply replies 'Pong!' to test if the bot is working"
        
        Bot.bot?.register("yeet", with: yeetOptions) { msg, args in
            if(args.count != 0) {
                msg.reply(with: args[0] + " got yeeted by: " + (msg.author?.username)!)
            } else {
                msg.reply(with: (msg.author?.username)! + " hella yeeted on everyone")
            }
        }
        
        Bot.bot?.register("ping", with: pingOptions) { msg, args in
            msg.reply(with: "Pong!")
        }
        
        Bot.bot?.connect()
    }
    
    func guildsAreReady() {
        guard (Bot.bot?.unavailableGuilds.isEmpty)! else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                self.guildsAreReady()
            }
            
            return
        }
        
        for guild in (Bot.bot?.guilds)! {
            Bot.guilds?.append(guild.value)
        }
        Bot.guildsAreReady = true
        self.botStarted = true
        Logs.logs = "Bot Ready\n"
        self.statusLabel.text = "Bot running"
        print("Bot started!")
        UIApplication.shared.endIgnoringInteractionEvents()
        activityView.stopAnimating()
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
        self.statusLabel.text = "Bot Offline"
        self.botStarted = false
        player.stop()
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    
    
}
