//
//  LightTheme.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 6.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

extension LightTheme {
    var contentTextColor: NSColor {
        return NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
    }
    
    @objc var controlBackgroundColor: NSColor {
        return NSColor.white
    }
    
    @objc var labelColor: NSColor {
        return NSColor.darkGray
    }
    
    @objc var secondaryLabelColor: NSColor {
        return NSColor.lightGray
    }
    
    @objc var contentBarColor: NSColor {
        return NSColor(hexString: "#f4f4f4")
    }
    
    @objc var gridColor: NSColor {
        return NSColor(hexString: "#F0F0F0")
    }
    
    @objc var seperatorColor: NSColor {
        return NSColor(hexString: "#F0F0F0")
    }
    
    @objc var rowSelectedColor: NSColor {
        return NSColor(hexString: "#F0F0F0")
    }
    
    @objc var statusGreenColor: NSColor {
        return NSColor(hexString: "#2ECC71")
    }
    
    @objc var statusOrangeColor: NSColor {
        return NSColor(hexString: "#F1C40F")
    }
    
    @objc var statusRedColor: NSColor {
        return NSColor(hexString: "#E74C3C")
    }
    
    @objc var projectListBackgroundColor: NSColor {
        return NSColor(hexString: "#232323")
    }
    
    @objc var deviceListBackgroundColor: NSColor {
        return NSColor(hexString: "#F6F6F6")
    }
    
    @objc var deviceRowSelectedColor: NSColor {
        return NSColor(hexString: "#ffffff")
    }
    
    @objc var packetListAndDetailBackgroundColor: NSColor {
        return NSColor(hexString: "#F0F0F0")
    }
}

extension LightTheme {
    
    
    @objc var clearIcon: NSImage {
        return NSImage(named: NSImage.Name("TrashIcon"))!
    }
    
    @objc var copyToClipboardIcon: NSImage {
        return NSImage(named: NSImage.Name("CopyIcon"))!
    }
}


extension LightTheme {
    
    @objc var httpMethodGetColor: NSColor {
        return NSColor(hexString: "#00cec9")
    }
    
    @objc var httpMethodPostColor: NSColor {
        return NSColor(hexString: "#fdcb6e")
    }
    
    @objc var httpMethodDeleteColor: NSColor {
        return NSColor(hexString: "#e17055")
    }
    
    @objc var httpMethodPutColor: NSColor {
        return NSColor(hexString: "#0984e3")
    }
    
    @objc var httpMethodDefaultColor: NSColor {
        return self.secondaryLabelColor
    }
}
