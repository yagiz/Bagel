//
//  DataJSONViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import WebKit

class DataJSONViewController: BaseViewController, WebFrameLoadDelegate {

    var viewModel: DataJSONViewModel?
    
    var isRaw: Bool = false
    
    @IBOutlet weak var webView: WebView!
    @IBOutlet var rawTextView: NSTextView!
    @IBOutlet weak var rawButton: NSButton!
    
    override func setup() {
        
        self.setupJSONViewer()
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.refresh()
    }
    
    
    func setupJSONViewer() {
        
        let filePath = Bundle.main.path(forResource: "jsonviewer", ofType: "html")!
        let fileURL = URL(fileURLWithPath: filePath)
        let urlRequest = URLRequest(url: fileURL)
        
        self.webView.mainFrame.load(urlRequest)
        self.webView.frameLoadDelegate = self
    }
    
    
    func refresh() {
        
        if let jsonString = self.viewModel?.currentJSONString {
            
            self.webView.windowScriptObject.callWebScriptMethod("renderJSONString", withArguments: [jsonString])
            
            
            let fullRange = NSRange.init(location: 0, length: jsonString.count)
            
            let attributedString = NSMutableAttributedString(string: jsonString)
            attributedString.addAttributes([.font : FontManager.codeFont(size: 13)], range: fullRange)
            
            self.rawTextView.textStorage?.setAttributedString(attributedString)
            
        }
        
        if self.isRaw {
            
            self.rawTextView.isHidden = false
            self.webView.isHidden = true
            self.rawButton.state = .on
            
        }else {
            
            self.rawTextView.isHidden = true
            self.webView.isHidden = false
            self.rawButton.state = .off
            
        }
    }
    
    
    @IBAction func rawButtonAction(_ sender: Any) {
        
        self.isRaw = !self.isRaw
        self.refresh()
    }
    
    @IBAction func copyButtonAction(_ sender: Any) {
        
    }
    
}
