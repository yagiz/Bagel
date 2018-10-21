//
//  DetailRequestParametersViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class KeyValueListViewController: BaseViewController {

    var viewModel: KeyValueViewModel?
    
    var isRaw: Bool = false
    
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet var rawTextView: NSTextView!
    
    @IBOutlet weak var rawTextScrollView: NSScrollView!
    @IBOutlet weak var tableScrollView: NSScrollView!
    
    @IBOutlet weak var contentHeaderBar: ContentBar!
    
    @IBOutlet weak var rawButton: NSButton!
    @IBOutlet weak var copyToClipboardButton: NSButton!
    
    override func setup() {
        
        self.copyToClipboardButton.image = ThemeImage.copyToClipboardIcon
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = ThemeColor.controlBackgroundColor
        self.tableView.gridColor = ThemeColor.gridColor

        self.setupTableViewHeaders()
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
        self.refresh()
    }
    
    
    func setupTableViewHeaders() {
        
        for tableColumn in self.tableView.tableColumns {
            
            tableColumn.headerCell = FlatTableHeaderCell(textCell: tableColumn.identifier.rawValue)
        }
    }
    
    
    func refresh() {
        
        self.rawTextView.textStorage?.setAttributedString(TextStyles.codeAttributedString(string: self.viewModel?.keyValueRepresentation?.rawString ?? ""))
        
        self.tableView.reloadData()
        
        if self.isRaw {
            
            self.rawTextScrollView.isHidden = false
            self.tableScrollView.isHidden = true
            self.contentHeaderBar.isHidden = true
            self.rawButton.state = .on
            
        }else {
            
            self.rawTextScrollView.isHidden = true
            self.tableScrollView.isHidden = false
            self.contentHeaderBar.isHidden = false
            self.rawButton.state = .off
            
        }
    
    }
    
    func copyToClipboard() {
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self.rawTextView!.string, forType: .string)
    }
    
    @IBAction func rawButtonAction(_ sender: Any) {
        
        self.isRaw = !self.isRaw
        self.refresh()
    }
    
    @IBAction func copyButtonAction(_ sender: Any) {
        
        self.viewModel?.copyToClipboard()
    }
}


extension KeyValueListViewController: NSTableViewDelegate, NSTableViewDataSource
{
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return self.viewModel?.itemCount() ?? 0
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if (tableColumn?.identifier)!.rawValue == "Key" {
            
            let cell: KeyValueTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.titleTextField.stringValue = self.viewModel?.item(at: row)?.key ?? ""
            return cell
            
        }else if (tableColumn?.identifier)!.rawValue == "Value" {
            
            let cell: KeyValueTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.titleTextField.stringValue = self.viewModel?.item(at: row)?.value ?? ""
            return cell
        }
        
        return nil
    }
    
}
