//
//  DetailOverviewViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class OverviewViewController: BaseViewController {

    @IBOutlet var overviewTextView: NSTextView!
    
    @IBOutlet weak var copyToClipboardButton: NSButton!
    
    var viewModel: OverviewViewModel?
    
    override func setup() {
        
        self.copyToClipboardButton.image = ThemeImage.copyToClipboardIcon
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.refresh()
    }
    
    
    func refresh() {
        
        self.overviewTextView.textStorage?.setAttributedString(TextStyles.codeAttributedString(string: self.viewModel?.overviewRepresentation?.rawString ?? ""))
    }
    
    @IBAction func copyButtonAction(_ sender: Any) {
        
        self.viewModel?.copyToClipboard()
    }
}
