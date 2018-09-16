//
//  BasicSection.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

import UIKit

class BasicSection: DynamicSection {
    
    var rows: [DynamicRow]
    var title: String?
    
    init(title: String?, rows: [DynamicRow]) {
        self.title = title
        self.rows = rows
    }
    
}
