//
//  StatusPacketTableCellView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class StatusPacketTableCellView: NSTableCellView {

    @IBOutlet weak var titleTextField: NSTextField!
    
    var packet: BagelPacket!
    {
        didSet
        {
            self.refresh()
        }
    }
    
    func refresh() {
        
        var titleTextColor = NSColor.black
        
        if let statusCodeInt = self.packet.requestInfo?.statusCode {
            
            if let statusCodeInt = Int(statusCodeInt) {
                
                if statusCodeInt >= 200 && statusCodeInt < 300 {
                    
                    titleTextColor = NSColor.green
                    
                }else if statusCodeInt >= 300 && statusCodeInt < 400 {
                    
                    titleTextColor = NSColor.orange
                    
                }else if statusCodeInt >= 400 {
                    
                    titleTextColor = NSColor.red
                }
                
            }
        }
        
        self.titleTextField.textColor = titleTextColor
        self.titleTextField.stringValue = self.packet.requestInfo?.statusCode ?? "-"
    }
    
}
