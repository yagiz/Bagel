//
//  DataTextRepresentation.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 10.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataTextRepresentation: DataRepresentation {
    
    var originalData: Data
    
    var type: DataRepresentationType = .text
    
    var rawString: String?
    
    var attributedString: NSAttributedString?
    

    init(data: Data) {
        
        self.originalData = data
    }
}
