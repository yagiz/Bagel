//
//  RequestParametersViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class RequestParametersViewModel: KeyValueViewModel {

    override func didSelectPacket() {
        
        super.didSelectPacket()
        
        self.keyValueRepresentation = nil
        self.items = []
        
        if let requestURLString = self.packet?.requestInfo?.url, let requestURL = URL(string: requestURLString) {
            
            self.keyValueRepresentation = ContentRepresentationParser.keyValueRepresentation(url: requestURL)
            self.items = self.keyValueRepresentation?.keyValues ?? []
            
        }
        
        self.onChange?()
    }
}
