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
import FaceCropper
import Alamofire

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
        print(UIDevice().type)
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
    
    //
    // Convert String to base64
    //
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //
    // Convert base64 to String
    //
    func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
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
                for attach in msg.attachments {
                    Logs.logs += " " + attach.filename
                }
            }
        }
        
        var pingOptions = CommandOptions()
        var yeetOptions = CommandOptions()
        var cropOptions = CommandOptions()
        cropOptions.description = "Crops an image to the first face it sees."
        yeetOptions.description = "Yeets whatever you want."
        pingOptions.description = "Simply replies 'Pong!' to test if the bot is working"
        
        Bot.bot?.register("yeet", with: yeetOptions) { msg, args in
            if(args.count != 0) {
                msg.reply(with: args[0] + " got yeeted by: " + (msg.author?.username)!)
            } else {
                msg.reply(with: (msg.author?.username)! + " hella yeeted on everyone")
            }
        }
        
        Bot.bot?.register("facecrop", with: cropOptions) { msg, args in
            if msg.attachments.count == 0 {
                msg.reply(with: "Please attach a photo with a face in it.")
                return
            }
                    var image: UIImage? = nil
                    let url = URL(string: (msg.attachments.first?.url)!)
                    if let data = try? Data(contentsOf: url!)
                    {
                        image = UIImage(data: data)
                    }
                    image?.face.crop { result in
                        switch result {
                        case .success(let faces):
                            // When the `Vision` successfully find faces, and `FaceCropper` cropped it.
                            // `faces` argument is a collection of cropped images.
                            for face in faces {
                                let _ = self.post(image: face, channel: msg.channel, for: "SwordBot")
                            }
                            
                        case .notFound:
                            // When the image doesn't contain any face, `result` will be `.notFound`.
                            print("not found")
                            msg.reply(with: "No faces detected. Please attach a photo with a face in it.")
                            return
                        case .failure(let error):
                            // When the any error occured, `result` will be `failure`.
                            print(error)
                            msg.reply(with: "Broke, sorry")
                            return
                        }
                    }
            /*let image = UIImage(named: "croptest.png")
            image?.face.crop { result in
                switch result {
                case .success(let faces):
                    // When the `Vision` successfully find faces, and `FaceCropper` cropped it.
                // `faces` argument is a collection of cropped images.
                    print(self.convertImageToBase64(image: faces.first!))
                    msg.reply(with: ["file": self.convertImageToBase64(image: faces.first!)])
                case .notFound:
                // When the image doesn't contain any face, `result` will be `.notFound`.
                    print("not found")
                case .failure(let error):
                    // When the any error occured, `result` will be `failure`.
                    print(error)
                }
            }*/
        }
        
        Bot.bot?.register("ping", with: pingOptions) { msg, args in
            msg.reply(with: "Pong!")
        }
        
        Bot.bot?.connect()
    }
    
    func post(image: UIImage, channel: Channel, for username: String) -> String {
        
        let imageData = UIImagePNGRepresentation(image)
        let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        let url = "https://api.imgur.com/3/upload"
        
        let parameters = [
            "image": base64Image
        ]
        
        var link = ""
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 1) {
                multipartFormData.append(imageData, withName: username, fileName: "\(username).png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: .utf8))!, withName: key)
            }}, to: url, method: .post, headers: ["Authorization": "Client-ID " + "94a7d8b1f23d2d1"],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { response in
                            //This is what you have been missing
                            let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any]
                            let imageDic = json?["data"] as? [String:Any]
                            link = imageDic?["link"] as! String
                            Bot.bot!.send(["file": link], to: channel.id)
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
        })
        return link
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
        
        Bot.bot?.editStatus(to: "online", playing: "with Sword!")
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
