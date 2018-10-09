//
//  ProjectsViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class ProjectsViewModel: BaseListViewModel<BagelProjectController> {

    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: NSNotification.Name(rawValue: "DidGetPacket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: NSNotification.Name(rawValue: "DidSelectProject"), object: nil)
    }
    
    var selectedItem: BagelProjectController? {
        
        return BagelController.shared.selectedProjectController
    }
    
    var selectedItemIndex: Int? {
        
        if let selectedItem = self.selectedItem {
            
            return self.items.firstIndex { $0 === selectedItem }
        }
        
        return nil
    }
    
    @objc func refreshItems() {
        
        self.set(items: BagelController.shared.projectControllers) 
        self.onChange?()
    }
}
