//
//  ServerTableViewCell.swift
//  SwordBot
//
//  Created by Elijah on 9/14/18.
//  Copyright © 2018 Elijah. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {
    //MARK: Properties

    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var serverImageView: UIImageView!
    let cellIdentifier = "ServerTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }*/

}
