//
//  DataTextViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataTextViewController: BaseViewController {

    var viewModel: DataTextViewModel?
    
    @IBOutlet var textView: NSTextView!
    
    override func setup() {
        
//        self.copyToClipboardButton.image = ThemeImage.clearIcon
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.refresh()
    }
    
    func refresh() {
        
        if let attributedText = self.viewModel?.dataRepresentation?.attributedString {
            
            TextStyles.addCodeAttributesToHTMLAttributedString(htmlAttributedString: attributedText)
            
            self.textView.string = ""
            self.textView.textStorage?.setAttributedString(attributedText)
        }
    }
    
    @IBAction func copyButtonAction(_ sender: Any) {
        
        self.viewModel?.copyToClipboard()
    }
}
