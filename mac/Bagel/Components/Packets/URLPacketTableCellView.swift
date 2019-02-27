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

    @IBOutlet private weak var titleTextField: NSTextField!
    
    var packet: BagelPacket? {
        didSet{
            guard let packet = packet else { return }
            refresh(with: packet)
        }
    }
    
    func refresh(with packet: BagelPacket) {
        titleTextField.textColor = ThemeColor.labelColor
        titleTextField.stringValue = packet.requestInfo?.url ?? ""
    }
    
}
