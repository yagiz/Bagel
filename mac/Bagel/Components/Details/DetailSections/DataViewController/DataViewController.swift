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
        
        if segue.identifier?.rawValue == "DataTextViewController" {
            
            self.dataTextViewController = segue.destinationController as? DataTextViewController
            self.dataTextViewController?.viewModel = DataTextViewModel()
        }
        
        
        if segue.identifier?.rawValue == "DataJSONViewController" {
            
            self.dataJSONViewController = segue.destinationController as? DataJSONViewController
            self.dataJSONViewController?.viewModel = DataJSONViewModel()
        }
    }
    
    
    func refresh() {
        
        if self.dataJSONViewController.viewModel?.parse(data: self.viewModel?.data) != nil {
            
            self.dataJSONViewController.view.isHidden = false
            self.dataTextViewController.view.isHidden = true
            
        }else if self.dataTextViewController.viewModel?.parse(data: self.viewModel?.data) != nil {
            
            self.dataJSONViewController.view.isHidden = true
            self.dataTextViewController.view.isHidden = false
            
        }
    }
    
    
    func copyToClipboard() {
        
//        NSPasteboard.general.clearContents()
//        NSPasteboard.general.setString(self.rawTextView!.string, forType: .string)
    }
}
