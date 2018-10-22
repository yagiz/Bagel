//
//  DatePacketTableCellView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 22.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class DatePacketTableCellView: NSTableCellView {
    
    @IBOutlet weak var titleTextField: NSTextField!
    
    var packet: BagelPacket!
    {
        didSet
        {
            self.refresh()
        }
    }
    
    func refresh() {
        
        self.titleTextField.textColor = ThemeColor.secondaryLabelColor
        self.titleTextField.stringValue = self.packet.requestInfo?.startDate?.readble ?? ""
    }
    
}
