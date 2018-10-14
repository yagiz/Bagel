//
//  KeyValueViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class KeyValueViewModel: BaseListViewModel<KeyValue> {

    var packet: BagelPacket?

    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didSelectPacket), name: BagelNotifications.didSelectPacket, object: nil)
    }
    
    
    func getKey(at: Int) -> String? {
        
        return self.items[at].firstKey
    }
    
    func getValue(at: Int) -> String? {
        
        return self.items[at].firstValue
    }
    
    func getRaw() -> String {
        
        var rawText = ""
        
        for item in self.items {
            
            if let key = item.firstKey, let value = item.firstValue {
                
                rawText += key + ": " + value + "\n"
                
            }
        }
        
        return rawText
    }
    
    @objc func didSelectPacket() {
        
        self.packet = BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
        
    }
}

