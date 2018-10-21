//
//  DataTextViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataTextViewModel: BaseViewModel {

    var dataRepresentation: DataRepresentation? {
        
        didSet {
            
            self.onChange?()
        }
    }

    func copyToClipboard() {
        self.dataRepresentation?.copyToClipboard()
    }
}
