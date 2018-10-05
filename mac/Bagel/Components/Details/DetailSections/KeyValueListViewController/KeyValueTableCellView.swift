//
//  KeyValueTableCellView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class KeyValueTableCellView: NSTableCellView {

    @IBOutlet weak var titleTextField: NSTextField!
    
    var keyValue: KeyValue!
    {
        didSet
        {
            self.refresh()
        }
    }
    
    func refresh() {
        
//        self.titleTextField.stringValue = self.project.projectName ?? ""
    }
}
