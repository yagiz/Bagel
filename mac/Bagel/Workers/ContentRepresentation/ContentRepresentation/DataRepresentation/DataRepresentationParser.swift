//
//  DataRepresentationParser.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 10.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

enum DataRepresentationType {
    
    case json
    case image
    case text
}

class DataRepresentation: ContentRepresentation {
    
    var originalData: Data?
    var type: DataRepresentationType!
    
    init(data: Data) {
        self.originalData = data
    }
}

class DataRepresentationParser {
    
    static func parse(data: Data) -> DataRepresentation? {
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    
                    let jsonData = DataJSONRepresentation(data: data)
                    jsonData.rawString = jsonString
                    return jsonData
                }
            }
            
        }else if let image = NSImage(data: data) {
            
            let textAttachmentCell = NSTextAttachmentCell(imageCell: image)
            let textAttachment = NSTextAttachment()
            textAttachment.attachmentCell = textAttachmentCell
            
            let attributedString = NSMutableAttributedString(attachment: textAttachment)
            
            let imageData = DataImageRepresentation(data: data)
            imageData.attributedString = attributedString
            return imageData
            
        }else if let htmlString = NSMutableAttributedString(html: data, documentAttributes: nil) {

            
            let textData = DataTextRepresentation(data: data)
            textData.rawString = htmlString.string
            textData.attributedString = htmlString
            return textData
            
        }else if let dataString = String(data: data, encoding: .utf8) {
            
            let textData = DataTextRepresentation(data: data)
            textData.rawString = dataString
            return textData
        }
        
        return nil
    }
}
