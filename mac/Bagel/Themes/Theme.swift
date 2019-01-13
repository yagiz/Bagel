//
//  ThemeColor.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 7.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

extension ThemeImage {
    
    open class var clearIcon: ThemeImage {
        return ThemeImage.image(with: #function)
    }
    
    open class var copyToClipboardIcon: ThemeImage {
        return ThemeImage.image(with: #function)
    }
}

extension ThemeColor {
    
    open override class var labelColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    open override class var controlBackgroundColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    open override class var gridColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    open override class var separatorColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    open override class var secondaryLabelColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var contentBarColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var rowSelectedColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var statusGreenColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var statusOrangeColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var statusRedColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var projectListBackgroundColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var deviceListBackgroundColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var deviceRowSelectedColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var packetListAndDetailBackgroundColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
}

extension ThemeColor {
    
    static var httpMethodGetColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var httpMethodPostColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var httpMethodDeleteColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var httpMethodPutColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
    
    static var httpMethodDefaultColor: ThemeColor {
        return ThemeColor.color(with: #function)
    }
}
