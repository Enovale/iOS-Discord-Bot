//
//  ViewController.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit
import Sword

class DynamicTVC: UITableViewController {
  
  var sections: [DynamicSection] = []
    
  var creatorname = "ElijahZAwesome"
    var creatordiscrim = "#6933"
  
  override func viewDidLoad() {
    if(Bot.guildsAreReady == false) {
        let alert = UIAlertController(title: "Can't open this page", message: "The bot isn't ready yet. Start your bot and come back.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        return
    }
    super.viewDidLoad()
    registerRows()
    setupTableViewSectionAndRows()
  }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Bot.guildsAreReady == false) {
            let alert = UIAlertController(title: "Can't open this page", message: "The bot isn't ready yet. Start your bot and come back.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        } else {
            registerRows()
            setupTableViewSectionAndRows()
        }
    }
  
  private func setupTableViewSectionAndRows() {
    // basic section
    
    var stats: [BasicCellWrapper] = []
    
    var isBot = ""
    if(Bot.bot!.user?.isBot)! {
        isBot = "User is Bot"
    } else {
        isBot = "User is not a Bot"
    }
    
    let botAvatar = Bot.bot!.user?.avatarUrl()
    
    stats.append(self.cellWrapper(title: isBot, image: "https://"))
    stats.append(self.cellWrapper(title: (Bot.bot!.user?.username)!, image: botAvatar!))
    
    let botStats = BasicSection(title: "Stats", rows: stats)
    sections.append(botStats)
    
    var servers: [BasicCellWrapper] = []
    for guild in Bot.guilds! {
        let members = "Server has " + String(describing: guild.memberCount!)
        let channels = " members and " + String(guild.channels.count)
        let emojis = " channels. Server has " + String(guild.emojis.count)
        let islarge = " emojis, and isLarge is: " + String(describing: guild.isLarge!)
        let stats = members + channels + emojis + islarge
        servers.append(self.cellWrapper(title: guild.name, image: "https://cdn.discordapp.com/icons/\(guild.id)/\(String(describing: guild.icon!)).png", name: guild.name, stats: stats))
    }
    
    let discordServers = BasicSection(title: "Servers", rows: servers)
    sections.append(discordServers)
    
    addSection()
  }
    
    private func cellWrapper(title: String, image: String, name: String = "Server", stats: String = "Nothin here") -> BasicCellWrapper {
        return BasicCellWrapper(title: title, image: image, invite: "<#String#>") { [weak self] text in
            self?.showAlert(title: name, message: stats)
            }
        }
  
  private func addSection() {
    sections.append(getFavouriteSection())
  }
  
  private func removeSection() {
    sections.removeLast()
  }
  
  private func registerRows() {
    let basicCellNib = UINib(nibName: "BasicCell", bundle: nil)
    self.tableView.register(basicCellNib, forCellReuseIdentifier: String(describing: BasicCell.self))
    let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
    self.tableView.register(textFieldCellNib, forCellReuseIdentifier: String(describing: TextFieldCell.self))
    let switchCellNib = UINib(nibName: "SwitchCell", bundle: nil)
    self.tableView.register(switchCellNib, forCellReuseIdentifier: String(describing: SwitchCell.self))
    let favouriteHeaderNib = UINib(nibName: "FavouriteHeader", bundle: nil)
    self.tableView.register(favouriteHeaderNib, forCellReuseIdentifier: String(describing: FavouriteHeader.self))
  }
  
    private func showAlert(title: String, message: String) {
    let alertVC = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    alertVC.addAction(okAction)
    present(alertVC, animated: true, completion: nil)
  }
    
    func test(user: User, error: RequestError) {
        creatorname = user.username!
        creatordiscrim = user.discriminator!
    }
  
  private func getFavouriteSection() -> BasicSection {
    //let id = Snowflake("314124904737931275")
    //Bot.bot!.getUser(id!, then: (test as? (User?, RequestError?) -> ())!)
    let creator = BasicCellWrapper(title: creatorname + creatordiscrim, image: "https://cdn.discordapp.com/avatars/314124904737931275/1326e5841c0e851f7a03d5bd81105d6d.png", invite: "<#String#>") { [weak self] text in self?.showAlert(title: "Creator", message: "App creator");
    }
    let info = BasicCellWrapper(title: "Info/How to use", image: "https://", invite: "<#String#>") { [weak self] text in self?.showAlert(title: "Info", message: """
Thanks for using my bot app! Using it is pretty simple. You've already started your bot, so hop into Discord and try '!ping'.
""")
    }
    let fruitsSection = BasicSection(title: "App Creator", rows: [creator, info])
    return fruitsSection
  }
    
}

// #MARK datasource and delegate methods of tableview

extension DynamicTVC {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].rows.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = sections[indexPath.section].rows[indexPath.row]
    let cell = row.getCellFor(tableView, indexPath: indexPath)
    cell.selectionStyle = .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = sections[indexPath.section].rows[indexPath.row]
    row.didSelectRow()
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return sections[section].header(tableView: tableView)
  }
  
}
