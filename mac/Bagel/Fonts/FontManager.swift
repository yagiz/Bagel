//
//  FontManager.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 5.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class FontManager: NSObject {

    static func mainFont(size: CGFloat) -> NSFont {
        return NSFont(name: "Effra-Regular", size: size)!
    }
    
    static func mainLightFont(size: CGFloat) -> NSFont {
        return NSFont(name: "EffraLight-Regular", size: size)!
    }
    
    static func mainBoldFont(size: CGFloat) -> NSFont {
        return NSFont(name: "Effra-Bold", size: size)!
    }
    
    static func mainMediumFont(size: CGFloat) -> NSFont {
        return NSFont(name: "EffraMedium-Regular", size: size)!
    }
    
    static func codeFont(size: CGFloat) -> NSFont {
        return NSFont(name: "Droid Sans Mono", size: size)!
    }
    
}
