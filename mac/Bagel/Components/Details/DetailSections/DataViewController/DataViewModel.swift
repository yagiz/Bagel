//
//  DataViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataViewModel: BaseViewModel {

    var packet: BagelPacket?
    var dataRepresentation: DataRepresentation?
    
    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didSelectPacket), name: BagelNotifications.didSelectPacket, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didSelectPacket), name: BagelNotifications.didUpdatePacket, object: nil)
    }
    
    
    @objc func didSelectPacket() {
        
        self.packet = BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
    }
}
