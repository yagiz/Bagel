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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: NSNotification.Name(rawValue: "DidGetPacket"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: NSNotification.Name(rawValue: "DidSelectDevice"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: NSNotification.Name(rawValue: "DidSelectProject"), object: nil)
    }
    
    var selectedItem: BagelDeviceController? {
        
        return BagelController.shared.selectedProjectController?.selectedDeviceController
    }
    
    var selectedItemIndex: Int? {
        
        if let selectedItem = self.selectedItem {
            
            return self.items.firstIndex { $0 === selectedItem }
        }
        
        return nil
    }
    
    @objc func refreshItems() {
        
        self.set(items: BagelController.shared.selectedProjectController?.deviceControllers ?? [])
        self.onChange?()
    }
    
}
