//
//  BagelDeviceController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 24/09/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BagelDeviceController: NSObject {

    var devideId: String?
    var deviceName: String?
    var deviceDescription: String?
    
    var packets: [BagelPacket] = []
    
    func addPacket(newPacket: BagelPacket) {
        
        for packet in self.packets {
            
            if packet.packetId == newPacket.packetId {
                
                packet.requestInfo = newPacket.requestInfo
            }
        }
        
        self.packets.append(newPacket)
    }
}
