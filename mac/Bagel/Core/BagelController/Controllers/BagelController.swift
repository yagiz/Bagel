//
//  BagelController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 24/09/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BagelController: NSObject {
    
    var projectControllers: [BagelProjectController] = []
    
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
    }
}
