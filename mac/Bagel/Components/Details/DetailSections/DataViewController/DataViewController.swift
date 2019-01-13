//
//  DataViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataViewController: BaseViewController {

    var viewModel: DataViewModel?
    
    var dataTextViewController: DataTextViewController!
    var dataJSONViewController: DataJSONViewController!
    
    override func setup() {
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.refresh()
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {

        if let destinationVC = segue.destinationController as? DataTextViewController {

            self.dataTextViewController = destinationVC
            self.dataTextViewController?.viewModel = DataTextViewModel()
        }
        
        
        if let destinationVC = segue.destinationController as? DataJSONViewController{
            
            self.dataJSONViewController = destinationVC
            self.dataJSONViewController?.viewModel = DataJSONViewModel()
        }
    }
    
    func refresh() {
        
        if let data = self.viewModel?.dataRepresentation {
            
            if data.type == .json {
                
                self.dataJSONViewController.viewModel?.dataRepresentation = self.viewModel?.dataRepresentation
                
                self.dataJSONViewController.view.isHidden = false
                self.dataTextViewController.view.isHidden = true
                
            } else {
                    
                self.dataTextViewController.viewModel?.dataRepresentation = self.viewModel?.dataRepresentation
                
                self.dataTextViewController.view.isHidden = false
                self.dataJSONViewController.view.isHidden = true
            }
            
        } else {
            
            self.dataJSONViewController.view.isHidden = true
            self.dataTextViewController.view.isHidden = true
        }
    }

}
