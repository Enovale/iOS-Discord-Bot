//
//  DynamicRow.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

protocol DynamicRow: class {
    func getCellFor(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didSelectRow()
}

// empty implementation so that only intrested cells need to worry about this function
extension DynamicRow {
    func didSelectRow() {
        
    }
}
