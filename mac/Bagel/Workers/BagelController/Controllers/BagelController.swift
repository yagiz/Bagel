//
//  BagelController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 24/09/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa


struct BagelNotifications {
    
    static let didGetPacket = NSNotification.Name("DidGetPacket")
    static let didUpdatePacket = NSNotification.Name("DidUpdatePacket")
    static let didSelectProject = NSNotification.Name("DidSelectProject")
    static let didSelectDevice = NSNotification.Name("DidSelectDevice")
    static let didSelectPacket = NSNotification.Name("DidSelectPacket")
}

class BagelController: NSObject, BagelPublisherDelegate {
    
    static let shared = BagelController()
    
    var projectControllers: [BagelProjectController] = []
    var selectedProjectController: BagelProjectController? {
        didSet {
            NotificationCenter.default.post(name: BagelNotifications.didSelectProject, object: nil)
        }
    }
    
    var publisher = BagelPublisher()
    
    override init() {
        
        super.init()
        self.publisher.delegate = self
        self.publisher.startPublishing()
        
    }
    
    func didGetPacket(publisher: BagelPublisher, packet: BagelPacket) {
        
        if self.addPacket(newPacket: packet) {
            NotificationCenter.default.post(name: BagelNotifications.didGetPacket, object: nil, userInfo: ["packet": packet])
            self.checkInitialSelection()
        }else{
            NotificationCenter.default.post(name: BagelNotifications.didUpdatePacket, object: nil, userInfo: ["packet": packet])
        }
    }
    
    @discardableResult
    func addPacket(newPacket: BagelPacket) -> Bool {
        
        for projectController in self.projectControllers {
            
            if projectController.projectName == newPacket.project?.projectName {
                
                return projectController.addPacket(newPacket: newPacket)
            }
        }
        
        
        let projectController = BagelProjectController()
        
        projectController.projectName = newPacket.project?.projectName
        projectController.addPacket(newPacket: newPacket)
        
        self.projectControllers.append(projectController)
        
        
        
        if self.projectControllers.count == 1 {
            
            self.selectedProjectController = self.projectControllers.first
        }
        
        return true
    }
    
    
    func checkInitialSelection() {
        if self.selectedProjectController?.selectedDeviceController?.packets.count == 1 {
            self.selectedProjectController?.selectedDeviceController?.notifyPacketSelection()
        }
    }
}
