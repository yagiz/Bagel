//
//  OverviewViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class OverviewViewModel: BaseViewModel {

    var packet: BagelPacket?
    var overviewRepresentation: OverviewRepresentation?
    
    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didSelectPacket), name: BagelNotifications.didSelectPacket, object: nil)
    }
    
    @objc func didSelectPacket() {
        
        self.packet = BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
        self.overviewRepresentation = nil
 
        if let requestInfo = self.packet?.requestInfo {
            
            self.overviewRepresentation = OverviewRepresentation(requestInfo: requestInfo)
        }
        
        self.onChange?()
    }
    
    func copyToClipboard() {
        self.overviewRepresentation?.copyToClipboard()
    }
}
