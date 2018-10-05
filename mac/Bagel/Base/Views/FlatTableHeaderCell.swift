//
//  BaseTableHeaderCell.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class FlatTableHeaderCell: NSTableHeaderCell {

    static let titleLeftMargin = CGFloat(0.0)
    static let titleTopMargin = CGFloat(0.0)
    
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
        
        NSColor.controlBackgroundColor.setFill()
        cellFrame.fill()
        
        let fullRange = NSRange.init(location: 0, length: self.stringValue.count)
        
        let attributedString = NSMutableAttributedString(string: self.stringValue)
        attributedString.addAttribute(.foregroundColor, value: NSColor.labelColor, range: fullRange)
        attributedString.addAttribute(.font, value: FontManager.mainMediumFont(size: 13), range: fullRange)
        
        attributedString.draw(in: NSRect.init(x: FlatTableHeaderCell.titleLeftMargin + cellFrame.origin.x, y: FlatTableHeaderCell.titleTopMargin, width: cellFrame.size.width, height: cellFrame.size.height))
    }
    
    
    override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
        
        self.drawInterior(withFrame: cellFrame, in: controlView)
    }
    
    
}
