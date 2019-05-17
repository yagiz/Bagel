//
//  DataJSONViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import WebKit
import macOSThemeKit
import Highlightr

class DataJSONViewController: BaseViewController {
    
    var viewModel: DataJSONViewModel?
    
    let highlightr = Highlightr()

    @IBOutlet var rawTextView: NSTextView!
    
    @IBOutlet weak var rawTextScrollView: NSScrollView!
    @IBOutlet weak var copyToClipboardButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func setup() {
        
        self.copyToClipboardButton.image = ThemeImage.copyToClipboardIcon
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedTheme(_:)), name: .didChangeTheme, object: nil)
        
        self.viewModel?.onChange = { [weak self] in
            self?.refresh()
        }
        
        self.refresh()
        self.refreshHighlightrTheme()
    }

    func refresh() {
        self.rawTextView.string = ""
        if let jsonString = self.viewModel?.dataRepresentation?.rawString {
            self.progressIndicator.isHidden = false
            self.progressIndicator.startAnimation(nil)
            DispatchQueue.global(qos: .background).async {
                if let highlightedCode = self.highlightr?.highlight(jsonString, as: "json") {
                    DispatchQueue.main.async {
                        self.rawTextView.textStorage?.setAttributedString(highlightedCode)
                        self.progressIndicator.isHidden = true
                        self.progressIndicator.stopAnimation(nil)
                    }
                }
            }
        }
    }
    
    func refreshHighlightrTheme() {
        if ThemeManager.shared.effectiveTheme === ThemeManager.lightTheme {
            self.highlightr?.setTheme(to: "github")
        }else if ThemeManager.shared.effectiveTheme === ThemeManager.darkTheme {
            self.highlightr?.setTheme(to: "paraiso-dark")
        }
    }
    
    @objc private func changedTheme(_ notification: Notification) {
        self.refreshHighlightrTheme()
    }

    @IBAction func copyButtonAction(_ sender: Any) {
        self.viewModel?.copyToClipboard()
    }
}
