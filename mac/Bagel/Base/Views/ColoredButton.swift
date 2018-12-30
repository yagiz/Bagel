//
//  ColoredButton.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 3.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class ColoredButton: NSButton {
    
    @IBInspectable open var textColor: NSColor = NSColor.black
    @IBInspectable open var selectedTextColor: NSColor = NSColor.red

    public override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
    }
    
    public required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        
        self.refreshTitleAttribute()
    }
    
    
    func refreshTitleAttribute() {
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = alignment
        
        if self.state == .on {
            
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: self.selectedTextColor, .paragraphStyle: titleParagraphStyle]
            self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: attributes)
            
        }else {
            
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: self.textColor, .paragraphStyle: titleParagraphStyle]
            self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: attributes)
            
        }
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        
        self.refreshTitleAttribute()
        super.draw(dirtyRect)
    }
}
