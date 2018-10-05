//
//  RequestHeadersViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class RequestHeadersViewModel: KeyValueViewModel {
    
    override func didSelectPacket() {
        
        super.didSelectPacket()
        self.items = self.packet?.requestInfo?.requestHeaders?.toKeyValueArray() ?? []
        self.onChange?()
    }
}
