//
//  ResponseHadersViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class ResponseHeadersViewModel: KeyValueViewModel {

    override func didSelectPacket() {
        
        super.didSelectPacket()
        
        self.keyValueRepresentation = nil
        self.items = []
        
        if let requestHeaders = self.packet?.requestInfo?.responseHeaders {
            
            self.keyValueRepresentation = ContentRepresentationParser.keyValueRepresentation(dictionary: requestHeaders)
            self.items = self.keyValueRepresentation?.keyValues ?? []
            
        }
        
        self.onChange?()
    }
}
