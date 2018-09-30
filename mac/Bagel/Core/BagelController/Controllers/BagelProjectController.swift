//
//  BagelProjectController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 24/09/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BagelProjectController: NSObject {
    
    var projectName: String?
    var deviceControllers: [BagelDeviceController] = []
    
    func addPacket(newPacket: BagelPacket) {
        
        for deviceController in self.deviceControllers {
            
            if deviceController.devideId == newPacket.device?.devideId {
                
                deviceController.addPacket(newPacket: newPacket)
            }
        }
        
        let deviceController = BagelDeviceController()
        
        deviceController.devideId = newPacket.device?.devideId
        deviceController.deviceName = newPacket.device?.deviceName
        deviceController.deviceDescription = newPacket.device?.deviceDescription
        
        deviceController.addPacket(newPacket: newPacket)
        
        self.deviceControllers.append(deviceController)
    }
}
