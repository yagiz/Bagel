//
//  BagelRequestPacket.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BagelPacket: Codable {

    var packetId: String?
    
    var requestInfo: BagelRequestInfo?
    
    var project: BagelProjectModel?
    var device: BagelDeviceModel?
    
}


