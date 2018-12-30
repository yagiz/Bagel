//
//  FlatTableRowView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 4.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class FlatTableRowView: NSTableRowView {

    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)

        if self.isSelected {
            
            ThemeColor.rowSelectedColor.setFill() 
            
        }else {
            
            NSColor.clear.setFill()
        }
        
        dirtyRect.fill()
        self.drawSeparator(in: dirtyRect)
    }
    
}
