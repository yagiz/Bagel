//
//  DetailViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DetailViewModel: BaseViewModel {

    var packet: BagelPacket?
    
    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPacket), name: BagelNotifications.didUpdatePacket, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPacket), name: BagelNotifications.didSelectPacket, object: nil)
    }
    
    @objc func didUpdatePacket(notification: Notification) {
        if let packet = notification.userInfo?["packet"] as? BagelPacket {
            if packet.packetId == self.packet?.packetId {
                self.packet = packet
                self.onChange?()
            }
        }
    }
    
    @objc func refreshPacket() {
        self.packet = BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
        self.onChange?()
    }
}
