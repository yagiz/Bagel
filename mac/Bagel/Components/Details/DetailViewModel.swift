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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetPacket), name: NSNotification.Name(rawValue: "DidGetPacket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetPacket), name: NSNotification.Name(rawValue: "DidSelectPacket"), object: nil)
    }
    
    @objc func didGetPacket() {
        
        self.packet = BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
        self.onChange?()
    }
}
