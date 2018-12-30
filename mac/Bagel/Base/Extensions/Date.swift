//
//  Date.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 22.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

extension Date {

    private static let readableFormat = "dd/MM/yyyy HH:mm:ss"
    var readble: String {
        return self.format(dateFormat: Date.readableFormat)
    }
    
    func format(dateFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
}
