//
//  ContentRepresentation.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 21.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

protocol ContentRepresentable {

    var rawString: String? {get}
    var attributedString: NSMutableAttributedString? {get}
    
    func copyToClipboard()
}

class ContentRepresentation: ContentRepresentable {
    
    var rawString: String?
    var attributedString: NSMutableAttributedString?
    
    func copyToClipboard() {
        
        if let rawString = self.rawString {
            
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(rawString, forType: .string)
        }
    }
}

class ContentRepresentationParser {
    
    static func dataRepresentation(data: Data) -> DataRepresentation? {
        
        return DataRepresentationParser.parse(data: data)
    }
    
    static func keyValueRepresentation(dictionary: Dictionary<String,String>) -> KeyValueRepresentation {
        
        let keyValueRepresentation = KeyValueRepresentation(keyValues: dictionary.toKeyValueArray())
        
        return keyValueRepresentation
    }
    
    static func keyValueRepresentation(url: URL) -> KeyValueRepresentation {
        
        let keyValueRepresentation = KeyValueRepresentation(keyValues: url.toKeyValueArray())
        
        return keyValueRepresentation
    }
    
    static func overviewRepresentation(requestInfo: BagelRequestInfo) -> ContentRepresentation {
        
        let overviewRepresentation = OverviewRepresentation(requestInfo: requestInfo)
        
        return overviewRepresentation
    }
}
