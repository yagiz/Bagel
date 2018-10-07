//
//  NSColor.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 6.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import AppKit

extension NSColor {
    
    convenience init(hexString: String) {
        
        var hex = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        
        guard hex.count == 3 || hex.count == 6 else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
            return
        }
        
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        let number = Int(hex, radix: 16)!
        let red = CGFloat((number >> 16) & 0xFF) / 255.0
        let green = CGFloat((number >> 8) & 0xFF) / 255.0
        let blue = CGFloat(number & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
