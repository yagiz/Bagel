//
//  TextStyles.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 8.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class TextStyles {

    static let codeAttributes = [NSAttributedStringKey.foregroundColor: ThemeColor.labelColor, NSAttributedStringKey.font: FontManager.codeFont(size: 13)]
    
    
    static func codeAttributedString(string: String) -> NSAttributedString {

        return NSAttributedString(string: string, attributes: codeAttributes)
    }

    
    static func addCodeAttributesToHTMLAttributedString(htmlAttributedString: NSMutableAttributedString) {
        
        htmlAttributedString.addAttributes(codeAttributes, range: NSRange.init(location: 0, length: htmlAttributedString.string.count))
    }
}
