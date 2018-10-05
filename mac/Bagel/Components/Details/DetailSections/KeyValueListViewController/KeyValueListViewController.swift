//
//  DetailRequestParametersViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class KeyValueListViewController: BaseViewController, NSTableViewDelegate, NSTableViewDataSource {

    var viewModel: KeyValueViewModel?
    
    var isRaw: Bool = false
    
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet var rawTextView: NSTextView!
    @IBOutlet weak var rawButton: NSButton!
    
    override func setup() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        
        self.rawTextView.string = self.viewModel?.getRaw() ?? ""
        self.tableView.reloadData()
        
        if self.isRaw {
            
            self.rawTextView.isHidden = false
            self.rawTextView.isSelectable = true
            
            self.tableView.isHidden = true
            self.rawButton.state = .on
            
        }else {
            
            self.rawTextView.isHidden = true
            self.rawTextView.isSelectable = false
            
            self.tableView.isHidden = false
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
        
        self.copyToClipboard()
    }
}


extension KeyValueListViewController
{
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return self.viewModel?.itemCount() ?? 0
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if (tableColumn?.identifier)!.rawValue == "Key" {
            
            let cell: KeyValueTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.titleTextField.stringValue = self.viewModel?.getKey(at: row) ?? ""
            return cell
            
        }else if (tableColumn?.identifier)!.rawValue == "Value" {
            
            let cell: KeyValueTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.titleTextField.stringValue = self.viewModel?.getValue(at: row) ?? ""
            return cell
        }
        
        return nil
    }
    
}
