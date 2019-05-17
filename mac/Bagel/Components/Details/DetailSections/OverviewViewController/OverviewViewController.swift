//
//  DetailOverviewViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class OverviewViewController: BaseViewController, DetailSectionProtocol {
    

    @IBOutlet var overviewTextView: NSTextView!
    
    @IBOutlet weak var curlButton: NSButton!
    @IBOutlet weak var copyToClipboardButton: NSButton!
    
    var viewModel: OverviewViewModel?
    
    private var isCurl: Bool = false
    
    override func setup() {
        
        self.copyToClipboardButton.image = ThemeImage.copyToClipboardIcon
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.refresh()
    }
    
    func refreshViewModel() {
        self.viewModel?.didSelectPacket()
    }
    
    func refresh() {
        
        if isCurl {

            self.overviewTextView.textStorage?.setAttributedString(TextStyles.codeAttributedString(string: self.viewModel?.curlRepresentation?.rawString ?? ""))
            curlButton.state = .on
        } else {

            self.overviewTextView.textStorage?.setAttributedString(TextStyles.codeAttributedString(string: self.viewModel?.overviewRepresentation?.rawString ?? ""))
            curlButton.state = .off
        }
    }
    
    @IBAction func curlButtonAction(_ sender: Any) {
        self.isCurl.toggle()
        self.refresh()
    }

    @IBAction func copyButtonAction(_ sender: Any) {
        if isCurl {
            self.viewModel?.copyCURLToClipboard()
        } else {
            self.viewModel?.copyTextToClipboard()
        }
    }
}
