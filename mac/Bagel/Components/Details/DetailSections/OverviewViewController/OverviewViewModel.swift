//
//  OverviewViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class OverviewViewModel: BaseViewModel {

    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didSelectPacket), name: BagelNotifications.didSelectPacket, object: nil)
    }
    
    @objc func didSelectPacket() {
        
//        self.packet = BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
//        
    }
    
    func refresh() {
        
        
    }
}
