//
//  DarkTheme.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 6.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

extension DarkTheme {
    
    var contentTextColor: NSColor {
        return NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
    }
    
    @objc var controlBackgroundColor: NSColor {
        return NSColor(hexString: "#1D1D1D")
    }
    
    @objc var labelColor: NSColor {
        return NSColor.white
    }
    
    @objc var secondaryLabelColor: NSColor {
        return NSColor(hexString: "#9C9C9C")
    }
    
    @objc var contentBarColor: NSColor {
        return NSColor(hexString: "#3A3A3A")
    }
    
    @objc var gridColor: NSColor {
        return NSColor(hexString: "#2A2A2A")
    }
    
    @objc var seperatorColor: NSColor {
        return NSColor(hexString: "#2A2A2A")
    }
    
    @objc var rowSelectedColor: NSColor {
        return NSColor(hexString: "#2A2A2A")
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
        return NSColor(hexString: "#262626")
    }
    
    @objc var deviceRowSelectedColor: NSColor {
        return NSColor(hexString: "#3A3A3A")
    }
    
    @objc var packetListAndDetailBackgroundColor: NSColor {
        return NSColor(hexString: "#323232")
    }
}

extension DarkTheme {
    
    
    @objc var clearIcon: NSImage {
        return NSImage(named: NSImage.Name("TrashIconDark"))!
    }
    
    @objc var copyToClipboardIcon: NSImage {
        return NSImage(named: NSImage.Name("CopyIconDark"))!
    }
}

extension DarkTheme {
    
    @objc var httpMethodGetColor: NSColor {
        return NSColor(hexString: "#00b894")
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
