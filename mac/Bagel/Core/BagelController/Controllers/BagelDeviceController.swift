//
//  BagelDeviceController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 24/09/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BagelDeviceController: NSObject {

    var deviceId: String?
    var deviceName: String?
    var deviceDescription: String?
    
    var packets: [BagelPacket] = []
    var selectedPacket: BagelPacket? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("DidSelectPacket"), object: nil)
        }
    }
    
    func addPacket(newPacket: BagelPacket) {
        
        for packet in self.packets {
            
            if packet.packetId == newPacket.packetId {
                
                packet.requestInfo = newPacket.requestInfo
                return
            }
        }
        
        self.packets.append(newPacket)
        
        
        
        if self.packets.count == 1 {
            
            self.selectedPacket = self.packets.first
        }
    }
    
    func clear() {
        
        self.packets.removeAll()
        self.selectedPacket = nil
    }
}
