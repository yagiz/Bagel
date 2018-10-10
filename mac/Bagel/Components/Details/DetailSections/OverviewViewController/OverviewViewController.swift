//
//  DetailOverviewViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class OverviewViewController: BaseViewController {

    @IBOutlet var overviewTextView: NSTextView!
    
    var viewModel: OverviewViewModel?
    
    override func setup() {
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.refresh()
    }
    
    
    func refresh() {
        
    }
}
