//
//  DynamicSection.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

protocol DynamicSection: class {
  var rows: [DynamicRow] { get set }
  var title: String? { get set }
  
  func header(tableView: UITableView) -> UITableViewCell?
  
}

extension DynamicSection {
  
  func header(tableView: UITableView) -> UITableViewCell? {
    return nil
  }
  
}
