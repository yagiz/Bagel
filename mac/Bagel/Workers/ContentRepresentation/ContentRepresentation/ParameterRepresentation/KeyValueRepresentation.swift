//
//  URLParameterRepresentation.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 10.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class KeyValueRepresentation: ContentRepresentation  {
    
    var keyValues: [KeyValue]?

    init(keyValues: [KeyValue]?) {
        
        super.init()
        
        self.keyValues = keyValues
        
        self.rawString = ""
        
        if let keyValues = keyValues {
            
            self.keyValues = keyValues
            
            self.rawString = ""
            
            for keyValue in keyValues {
                
                let key = (keyValue.key ?? "")
                let value = (keyValue.value ?? "")
                
                self.rawString = self.rawString! + key + ": " +  value + "\n"
            }
        }
    }
}
