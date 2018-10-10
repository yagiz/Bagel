//
//  RequestBodyViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class RequestBodyViewModel: DataViewModel {

    override func didSelectPacket() {
        
        super.didSelectPacket()
        
        self.dataRepresentation = nil
        
        if let data = self.packet?.requestInfo?.requestBody?.base64Data {
            
            self.dataRepresentation = DataRepresentationParser.parse(data: data)
        }
        
        self.onChange?()
    }
}
