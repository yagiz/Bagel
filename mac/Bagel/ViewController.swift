//
//  ViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/07/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class ViewController: NSViewController {

    var projectsViewController: ProjectsViewController?
    var devicesViewController: DevicesViewController?
    var packetsViewController: PacketsViewController?
    var detailVeiwController: DetailViewController?
    
    @IBOutlet weak var projectsBackgroundBox: NSBox!
    @IBOutlet weak var devicesBackgroundBox: NSBox!
    @IBOutlet weak var packetsBackgroundBox: NSBox!
    
    @IBOutlet weak var rightSideBox: BaseSplitView!
    var clickCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = BagelController.shared
        
        self.projectsBackgroundBox.fillColor = ThemeColor.projectListBackgroundColor
        self.devicesBackgroundBox.fillColor = ThemeColor.deviceListBackgroundColor
        self.packetsBackgroundBox.fillColor = ThemeColor.packetListAndDetailBackgroundColor
        
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {

        if let destinationVC = segue.destinationController as? ProjectsViewController {
            
            self.projectsViewController = destinationVC
            self.projectsViewController?.viewModel = ProjectsViewModel()
            self.projectsViewController?.viewModel?.register()
            
            self.projectsViewController?.onProjectSelect = { (selectedProjectController) in
                
                BagelController.shared.selectedProjectController = selectedProjectController
            }
            
        }
        

        if let destinationVC = segue.destinationController as? DevicesViewController {
            
            self.devicesViewController = destinationVC
            self.devicesViewController?.viewModel = DevicesViewModel()
            self.devicesViewController?.viewModel?.register()
            
            self.devicesViewController?.onDeviceSelect = { (selectedDeviceController) in
                
                BagelController.shared.selectedProjectController?.selectedDeviceController = selectedDeviceController
            }
            
        }
        

        if let destinationVC = segue.destinationController as? PacketsViewController {
            
            self.packetsViewController = destinationVC
            self.packetsViewController?.viewModel = PacketsViewModel()
            self.packetsViewController?.viewModel?.register()
            
            self.packetsViewController?.onPacketSelect = { (selectedPacket) in
            BagelController.shared.selectedProjectController?.selectedDeviceController?.select(packet: selectedPacket)
            }
            
        }
        

        if let destinationVC = segue.destinationController as? DetailViewController {
            
            self.detailVeiwController = destinationVC
            self.detailVeiwController?.viewModel = DetailViewModel()
            self.detailVeiwController?.viewModel?.register()
            
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func mouseUp(with event: NSEvent) {
       
        // We just want to click on the top. That's why we're calculating that part.
        let topBarHeight = view.frame.height - rightSideBox.frame.height
   
        if event.locationInWindow.y > view.frame.height - topBarHeight {
            // For double click
            if self.clickCount == 1 {
                view.window?.zoom(self)
                
                // reset again
                self.clickCount = 0
            }
            
            self.clickCount += 1
        }
    }

    
    
}

