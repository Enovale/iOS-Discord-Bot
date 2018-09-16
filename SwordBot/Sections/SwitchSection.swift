//
//  SwitchSection.swift
//  DynamicTableViewRowsDemo
//
//  Created by Subash Poudel on 2/11/17.
//  Copyright © 2017 leapfrog. All rights reserved.
//

typealias SwitchSectionCompletion = (Bool) -> ()

class SwitchSection: DynamicSection {
  var rows: [DynamicRow]
  var title: String?
  var requiredRows: [DynamicRow]
  var optionalRows: [DynamicRow]
  var completion: SwitchSectionCompletion
  var showOptionalRows = false {
    didSet {
      if showOptionalRows {
        rows = requiredRows + optionalRows
      } else {
        rows = requiredRows
      }
    }
  }
  
  init(title: String?, requiredRows: [DynamicRow], optionalRows: [DynamicRow], switchRow: SwitchCellWrapper, completion: @escaping SwitchSectionCompletion) {
    self.title = title
    self.requiredRows = requiredRows
    self.optionalRows = optionalRows
    self.rows = requiredRows
    self.completion = completion
    switchRow.delegate = self
  }
  
}

extension SwitchSection: SwitchCellDelegate {
  func switchStateChanged(switchState: Bool) {
    showOptionalRows = switchState
    completion(switchState)
  }
}
