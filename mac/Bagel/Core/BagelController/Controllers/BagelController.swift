//
//  BagelController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 24/09/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BagelController: NSObject, BagelPublisherDelegate {
    
    static let shared = BagelController()
    
    var projectControllers: [BagelProjectController] = []
    var selectedProjectController: BagelProjectController? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("DidSelectProject"), object: nil)
        }
    }
    
    var publisher = BagelPublisher()
    
    override init() {
        
        super.init()
        self.publisher.delegate = self
        self.publisher.startPublishing()
        
    }
    
    func didGetPacket(publisher: BagelPublisher, packet: BagelPacket) {
        
        self.addPacket(newPacket: packet)
        NotificationCenter.default.post(name: NSNotification.Name("DidGetPacket"), object: nil)
    }
    
    func addPacket(newPacket: BagelPacket) {
        
        for projectController in self.projectControllers {
            
            if projectController.projectName == newPacket.project?.projectName {
                
                projectController.addPacket(newPacket: newPacket)
                return
            }
        }
        
        
        let projectController = BagelProjectController()
        
        projectController.projectName = newPacket.project?.projectName
        projectController.addPacket(newPacket: newPacket)
        
        self.projectControllers.append(projectController)
        
        
        
        if self.projectControllers.count == 1 {
            
            self.selectedProjectController = self.projectControllers.first
        }
    }
}
