//
//  SwitchCell.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
  func switchStateChanged(switchState: Bool)
}

class SwitchCell: UITableViewCell {
  
  @IBOutlet var label: UILabel!
  var delegate: SwitchCellDelegate?
  
  @IBAction func switchStateChanged(_ sender: UISwitch) {
    delegate?.switchStateChanged(switchState: sender.isOn)
  }
}

class SwitchCellWrapper: DynamicRow {
  
  var title: String?
  var delegate: SwitchCellDelegate?
  
  init(title: String?) {
    self.title = title
  }
  
  
  func getCellFor(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SwitchCell.self), for: indexPath) as! SwitchCell
    cell.label.text = title
    cell.delegate = delegate
    return cell
  }
}
