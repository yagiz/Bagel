//
//  DataTextViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataTextViewModel: BaseViewModel {

    var attributedText: NSAttributedString?
    
    func parse(data: Data?) -> NSAttributedString? {
        
        guard let data = data else { return nil }
        
        if let image = NSImage(data: data) {
            
            let textAttachmentCell = NSTextAttachmentCell(imageCell: image)
            let textAttachment = NSTextAttachment()
            textAttachment.attachmentCell = textAttachmentCell
            
            self.attributedText = NSMutableAttributedString(attachment: textAttachment)
            self.onChange?()
            
            return self.attributedText
            
        }else if let htmlString = NSAttributedString(html: data, documentAttributes: nil) {
            
            self.attributedText = htmlString
            self.onChange?()
            
            return self.attributedText
            
        }else if let dataString = String(data: data, encoding: .utf8) {
            
            self.attributedText = NSAttributedString(string: dataString)
            self.onChange?()
            
            return self.attributedText
        }
        
        return nil
    }
}
