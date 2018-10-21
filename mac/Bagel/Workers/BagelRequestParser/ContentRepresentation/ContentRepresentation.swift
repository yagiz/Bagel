//
//  ContentRepresentation.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 21.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

protocol ContentRepresentation {

    var rawString: String? {get}
    var attributedString: NSAttributedString? {get}
    
}

class ContentRepresentationParser {
    
    static func parseData(data: Data) -> DataRepresentation? {
        
        return DataRepresentationParser.parse(data: data)
    }
    
    static func parseDictionary(dictionary: Dictionary<String,String>) -> KeyValueRepresentation {
        
        let keyValueRepresentation = KeyValueRepresentation(keyValues: dictionary.toKeyValueArray())
        
        return keyValueRepresentation
    }
    
    static func parseURL(url: URL) -> KeyValueRepresentation {
        
        let keyValueRepresentation = KeyValueRepresentation(keyValues: url.toKeyValueArray())
        
        return keyValueRepresentation
    }
}
