//
//  FavouriteHeader.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 4/16/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import Foundation
import UIKit

class FavouriteHeader: UITableViewCell {
  
  weak var delegate: FavouriteHeaderDelegate?

  @IBAction func addSection(_ sender: UIButton) {
    delegate?.addPressed()
  }
  
  @IBAction func removeSection(_ sender: UIButton) {
    delegate?.removePressed()
  }
  
}

protocol FavouriteHeaderDelegate: class {
  func addPressed()
  func removePressed()
}
