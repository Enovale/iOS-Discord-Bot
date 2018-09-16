//
//  FavouriteSection.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 4/16/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import Foundation
import UIKit

typealias AddSection = () -> ()
typealias RemoveSection = () -> ()

class FavouriteSection: DynamicSection {
  
  var rows: [DynamicRow]
  var title: String?
  let addSection: AddSection
  let removeSection: RemoveSection
  
  init(title: String, rows: [DynamicRow], addSection: @escaping AddSection, removeSection: @escaping RemoveSection) {
    self.rows = rows
    self.title = title
    self.addSection = addSection
    self.removeSection = removeSection
  }
  
  func header(tableView: UITableView) -> UITableViewCell? {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavouriteHeader.self))! as! FavouriteHeader
    cell.delegate = self
    return cell
  }
  
}

extension FavouriteSection: FavouriteHeaderDelegate {
  
  func addPressed() {
    addSection()
  }
  
  func removePressed() {
    removeSection()
  }
  
}
