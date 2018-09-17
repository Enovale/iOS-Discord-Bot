//
//  TextCell.swift
//  SwordBot
//
//  Created by Elijah on 9/16/18.
//  Copyright © 2018 Elijah. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}

typealias BasicTextCellTapCompletion = (String) -> ()

class BasicTextCellWrapper: DynamicRow {
    
    var title: String
    var completion: BasicTextCellTapCompletion?
    
    init(title: String, completion: BasicTextCellTapCompletion?) {
        self.title = title
        self.completion = completion
    }
    
    func getCellFor(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
        cell.label.text = title
        return cell
    }
    
    func didSelectRow() {
        completion?(title)
    }
    
}
