//
//  URLPacketTableCellView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class URLPacketTableCellView: NSTableCellView {

    @IBOutlet weak var titleTextField: NSTextField!
    
    var packet: BagelPacket!
    {
        didSet
        {
            self.refresh()
        }
    }
    
    func refresh() {
        
        self.titleTextField.textColor = ThemeColor.labelColor
        self.titleTextField.stringValue = self.packet.requestInfo?.url ?? ""
    }
    
}
