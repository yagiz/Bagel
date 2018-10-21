//
//  DataImageRepresentation.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 10.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataImageRepresentation: DataRepresentation {

    override init(data: Data) {
        
        super.init(data: data)
        self.type = .image
    }
    
    override func copyToClipboard() {
        
        if let originalData = self.originalData {
            
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setData(originalData, forType: .png)
        }
    }
}
