//
//  BagelData.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 10.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class JSONRepresentation: DataRepresentation  {
    
    var originalData: Data
    
    var type: DataRepresentationType = .json
    
    var rawString: String?
    
    var attributedString: NSAttributedString?
    
    
    init(data: Data) {
        
        self.originalData = data
    }
}
