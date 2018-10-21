//
//  BagelExtensions.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 21.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

extension String {
    
    var base64Data: Data? {
        
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
    }
}

extension URL {
    
    func toKeyValueArray() -> [KeyValue] {
        
        var array = [KeyValue]()
        
        if let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems {
            
            for queryItem in queryItems {
                
                array.append(KeyValue(key: queryItem.name, value: queryItem.value))
                
            }
        }
        
        return array
    }
}

extension Dictionary where Key == String, Value == String {
    
    func toKeyValueArray() -> [KeyValue] {
        
        var array = [KeyValue]()
        
        for key in self.keys {
            array.append(KeyValue(key: key, value: self[key]))
        }
        
        return array
    }
}
