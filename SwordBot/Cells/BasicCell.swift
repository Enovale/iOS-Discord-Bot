//
//  BasicCell.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var imageObj: UIImageView?
}

typealias BasicCellTapCompletion = (String) -> ()

class BasicCellWrapper: DynamicRow {
    
    var title: String
    var completion: BasicCellTapCompletion?
    var image: String
    var invite: String
    
    init(title: String, image: String, invite: String, completion: BasicCellTapCompletion?) {
        self.title = title
        self.completion = completion
        self.image = image
        self.invite = invite
    }
    
    func getCellFor(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasicCell.self), for: indexPath) as! BasicCell
        cell.label.text = title
        cell.imageObj?.load(url: URL(string: String(describing: image))!)
        return cell
    }
    
    func didSelectRow() {
        completion?(title)
    }
    
}
