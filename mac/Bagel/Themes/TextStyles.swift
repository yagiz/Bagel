//
//  CodeAttributedString.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 8.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class TextStyles {

    static func codeAttributedString(string: String) -> NSAttributedString {

        let attributes: [NSAttributedStringKey : Any] = [.foregroundColor: ThemeColor.labelColor, .font: FontManager.codeFont(size: 13)]
        
        return NSAttributedString(string: string, attributes: attributes)
        
    }

    static func addCodeAttributesToHTMLAttributedString(htmlAttributedString: NSMutableAttributedString) {
        
        htmlAttributedString.addAttributes([.foregroundColor: ThemeColor.labelColor, .font: FontManager.codeFont(size: 13)], range: NSRange.init(location: 0, length: htmlAttributedString.string.count))

    }
}
