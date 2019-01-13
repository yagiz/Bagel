//
//  MethodPacketTableCellView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 31.12.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class MethodPacketTableCellView: NSTableCellView {
    
    @IBOutlet weak var titleTextField: NSTextField!
    
    var packet: BagelPacket!
    {
        didSet
        {
            self.refresh()
        }
    }
    
    func refresh() {
        
        var methodColor = ThemeColor.httpMethodDefaultColor
        
        if self.packet.requestInfo?.requestMethod == "GET" {
            methodColor = ThemeColor.httpMethodGetColor
        }else if self.packet.requestInfo?.requestMethod == "POST" {
            methodColor = ThemeColor.httpMethodPostColor
        }else if self.packet.requestInfo?.requestMethod == "PUT" {
            methodColor = ThemeColor.httpMethodPutColor
        }else if self.packet.requestInfo?.requestMethod == "DELETE" {
            methodColor = ThemeColor.httpMethodDeleteColor
        }
        
        self.titleTextField.textColor = methodColor
        self.titleTextField.stringValue = self.packet.requestInfo?.requestMethod ?? ""
    }
    
}
