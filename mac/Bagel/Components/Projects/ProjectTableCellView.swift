//
//  ProjectCell.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class ProjectTableCellView: NSTableCellView {

    @IBOutlet weak var titleTextField: NSTextField!
    
    var project: String!
    {
        didSet
        {
            self.refresh()
        }
    }

    func refresh() {
        
        self.titleTextField.stringValue = self.project
    }
}
