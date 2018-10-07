//
//  FlatTableRowView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 4.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

struct RowColors {
    
    static let normal = NSColor.clear
    
    static var selected: NSColor {
        
//        return NSColor(hexString: "#303030")
        
        return NSColor(hexString: "#f4f4f4")
    }
}

class FlatTableRowView: NSTableRowView {

    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)

        if self.isSelected {
            
            ThemeColor.rowSelectedColor.setFill() 
            
        }else {
            
            RowColors.normal.setFill()
        }
        
        dirtyRect.fill()
        self.drawSeparator(in: dirtyRect)
    }
    
}
