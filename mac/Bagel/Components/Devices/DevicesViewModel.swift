//
//  DevicesViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DevicesViewModel: BaseListViewModel<BagelDeviceController>  {

    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetPacket), name: NSNotification.Name(rawValue: "DidGetPacket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetPacket), name: NSNotification.Name(rawValue: "DidSelectProject"), object: nil)
    }
    
    @objc func didGetPacket() {
        
        self.items = BagelController.shared.selectedProjectController?.deviceControllers ?? []
        self.onChange?()
    }
    
}
