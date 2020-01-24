//
//  CheckListModel.swift
//  TodoListy
//
//  Created by Manpreet Singh on 2020-01-16.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import Foundation

class CheckListItem: NSObject {
    
    @objc var text = ""
    var checked = false

    func toggleChecked() {
        checked = !checked
    }
}
