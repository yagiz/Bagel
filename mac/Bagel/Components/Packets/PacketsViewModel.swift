//
//  PacketViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class PacketsViewModel: BaseListViewModel<BagelPacket>  {
    
    var filterTerm = "" {
        didSet {
            self.refreshItems()
        }
    }
    
    func register() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didGetPacket, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didUpdatePacket, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didSelectProject, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didSelectDevice, object: nil)
    }
    
    var selectedItem: BagelPacket? {
        return BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
    }
    
    var selectedItemIndex: Int? {
        guard let selectedItem = self.selectedItem else { return nil }
        
        return self.items.firstIndex { $0 === selectedItem }
    }
    
    @objc func refreshItems() {
        items = filter(items: BagelController.shared.selectedProjectController?.selectedDeviceController?.packets ?? [])
        onChange?()
    }
    
    func filter(items: [BagelPacket]?) -> [BagelPacket] {
        guard let items = items, filterTerm.count > 0 else {
            return BagelController.shared.selectedProjectController?.selectedDeviceController?.packets ?? []
        }
        
        return items.filter({ (packet) -> Bool in
            return packet.requestInfo?.url?.contains(self.filterTerm) ?? true
        })
    }
    
    func clearPackets() {
        BagelController.shared.selectedProjectController?.selectedDeviceController?.clear()
        self.refreshItems()
    }
}
