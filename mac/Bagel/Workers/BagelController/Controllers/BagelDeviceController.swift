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
    private(set) var selectedPacket: BagelPacket?
    
    func select(packet: BagelPacket?) {
        self.selectedPacket = packet
        self.notifyPacketSelection()
    }
    
    func notifyPacketSelection() {
        NotificationCenter.default.post(name: BagelNotifications.didSelectPacket, object: nil)
    }
    
    @discardableResult
    func addPacket(newPacket: BagelPacket) -> Bool {
        
        for packet in self.packets {
            
            if packet.packetId == newPacket.packetId {
                
                packet.requestInfo = newPacket.requestInfo
                return false
            }
        }
        
        self.packets.append(newPacket)
        
        
        
        if self.packets.count == 1 {
            
            self.selectedPacket = self.packets.first
        }
        
        return true
    }
    
    func clear() {
        
        self.packets.removeAll()
        self.select(packet: nil)
    }
}
