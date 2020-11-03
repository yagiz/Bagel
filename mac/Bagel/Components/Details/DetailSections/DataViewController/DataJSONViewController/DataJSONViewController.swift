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

class DataJSONViewController: BaseViewController {
    
    var viewModel: DataJSONViewModel?

    @IBOutlet weak var copyToClipboardButton: NSButton!
    @IBOutlet weak var codeMirrorContainerView: NSView!
    private lazy var codeMirrorView = CodeMirrorWebView()

    override func setup() {
        setupCodeMirror()

        self.copyToClipboardButton.image = ThemeImage.copyToClipboardIcon
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedTheme(_:)), name: .didChangeTheme, object: nil)
        
        self.viewModel?.onChange = { [weak self] in
            self?.refresh()
        }
        
        self.refresh()
        self.refreshHighlightrTheme()
    }

    func refresh() {
        codeMirrorView.setContent("")
        guard let jsonString = self.viewModel?.dataRepresentation?.rawString else {
            return
        }
        codeMirrorView.setContent(jsonString)
    }
    
    func refreshHighlightrTheme() {
        if ThemeManager.shared.effectiveTheme === ThemeManager.lightTheme {
            codeMirrorView.setDarkTheme(false)
        } else if ThemeManager.shared.effectiveTheme === ThemeManager.darkTheme {
            codeMirrorView.setDarkTheme(true)
        }
    }
    
    @objc private func changedTheme(_ notification: Notification) {
        self.refreshHighlightrTheme()
    }

    @IBAction func copyButtonAction(_ sender: Any) {
        self.viewModel?.copyToClipboard()
    }
}

// MARK: - Private

extension DataJSONViewController {

    private func setupCodeMirror() {
        codeMirrorView.setDefaultTheme()
        codeMirrorView.translatesAutoresizingMaskIntoConstraints = false
        codeMirrorContainerView.addSubview(codeMirrorView)
        codeMirrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        codeMirrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        codeMirrorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        codeMirrorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
