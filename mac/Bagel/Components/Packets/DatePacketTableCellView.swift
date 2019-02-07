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
    
    @IBOutlet private weak var titleTextField: NSTextField!
    
    var packet: BagelPacket? {
        didSet{
          guard let packet = packet else { return }
            refresh(with: packet)
        }
    }
    
    func refresh(with packet: BagelPacket) {
        titleTextField.textColor = ThemeColor.secondaryLabelColor
        titleTextField.stringValue = packet.requestInfo?.startDate?.readable ?? ""
    }
    
}
