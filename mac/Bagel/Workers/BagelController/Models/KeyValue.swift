//
//  KeyValue.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 21.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class KeyValue: Codable {
    
    var key: String?
    var value: String?
    
    init(key: String?, value: String?) {
        self.key = key
        self.value = value
    }
}
