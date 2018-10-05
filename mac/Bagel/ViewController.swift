//
//  ViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/07/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var projectsViewController: ProjectsViewController?
    var devicesViewController: DevicesViewController?
    var packetsViewController: PacketsViewController?
    var detailVeiwController: DetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BagelController.shared
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier?.rawValue == "ProjectsViewController" {
            
            self.projectsViewController = segue.destinationController as? ProjectsViewController
            self.projectsViewController?.viewModel = ProjectsViewModel()
            self.projectsViewController?.viewModel?.register()
            
            self.projectsViewController?.onProjectSelect = { (selectedProjectController) in
                
                BagelController.shared.selectedProjectController = selectedProjectController
            }
            
        }
        
        
        if segue.identifier?.rawValue == "DevicesViewController" {
            
            self.devicesViewController = segue.destinationController as? DevicesViewController
            self.devicesViewController?.viewModel = DevicesViewModel()
            self.devicesViewController?.viewModel?.register()
            
            self.devicesViewController?.onDeviceSelect = { (selectedDeviceController) in
                
                BagelController.shared.selectedProjectController?.selectedDeviceController = selectedDeviceController
            }
            
        }
        
        
        if segue.identifier?.rawValue == "PacketsViewController" {
            
            self.packetsViewController = segue.destinationController as? PacketsViewController
            self.packetsViewController?.viewModel = PacketsViewModel()
            self.packetsViewController?.viewModel?.register()
            
            self.packetsViewController?.onPacketSelect = { (selectedPacket) in
                
                BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket = selectedPacket
            }
            
        }
        
        
        if segue.identifier?.rawValue == "DetailViewController" {
            
            self.detailVeiwController = segue.destinationController as? DetailViewController
            self.detailVeiwController?.viewModel = DetailViewModel()
            self.detailVeiwController?.viewModel?.register()
            
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

