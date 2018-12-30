//
//  BaseTableHeaderCell.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class FlatTableHeaderCell: NSTableHeaderCell {

    var titleLeftMargin = CGFloat(5.0)
    var titleTopMargin = CGFloat(0.0)
    
    override init(textCell string: String) {
        
        super.init(textCell: string)
    }
    
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        self.drawInterior(withFrame: cellFrame, in: controlView)
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        
        ThemeColor.contentBarColor.setFill()
        cellFrame.fill()
        
        let fullRange = NSRange.init(location: 0, length: self.stringValue.count)
        
        let attributedString = NSMutableAttributedString(string: self.stringValue)
        attributedString.addAttribute(.foregroundColor, value: NSColor.labelColor, range: fullRange)
        attributedString.addAttribute(.font, value: FontManager.mainMediumFont(size: 13), range: fullRange)
        
        self.attributedStringValue = attributedString
        super.drawInterior(withFrame: NSRect.init(x: self.titleLeftMargin + cellFrame.origin.x, y: self.titleTopMargin, width: cellFrame.size.width, height: cellFrame.size.height), in: controlView)
    }
    
    
    override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
        
        self.drawInterior(withFrame: cellFrame, in: controlView)
    }
    
    
}
