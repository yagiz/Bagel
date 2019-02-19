//
//  PacketsViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class PacketsViewController: BaseViewController {

    static var statusColumnWidth = CGFloat(50.0)
    static var methodColumnWidth = CGFloat(55.0)
    static var dateColumnWidth = CGFloat(150.0)
    
    var viewModel: PacketsViewModel?
    var onPacketSelect : ((BagelPacket?) -> ())?
    
    @IBOutlet weak var clearButton: NSButton!
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var filterTextField: NSTextField!
    
    override func setup() {
        
        self.clearButton.image = ThemeImage.clearIcon
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = ThemeColor.controlBackgroundColor
        self.tableView.gridColor = ThemeColor.gridColor
        
        self.filterTextField.backgroundColor = ThemeColor.controlBackgroundColor
        self.filterTextField.delegate = self
        
        self.viewModel?.onChange = { [weak self] in
            self?.refresh()
        }
        
        self.setupTableViewHeaders()
    }
    
    
    func refresh() {
        self.tableView.reloadData()
        
        if let selectedItemIndex = self.viewModel?.selectedItemIndex {
            self.tableView.selectRowIndexes(IndexSet(integer: selectedItemIndex), byExtendingSelection: false)
        }
        
        if isScrolledToBottom() {
            self.scrollToBottom()
        }
    }
    
    func setupTableViewHeaders() {
        
        for tableColumn in self.tableView.tableColumns {
            
            switch tableColumn.identifier.rawValue {
            case "statusCode":
                tableColumn.headerCell = FlatTableHeaderCell(textCell: "Status")
                tableColumn.width = PacketsViewController.statusColumnWidth
            case "method":
                tableColumn.headerCell = FlatTableHeaderCell(textCell: "Method")
                tableColumn.width = PacketsViewController.methodColumnWidth
            case "url":
                tableColumn.headerCell = FlatTableHeaderCell(textCell: "URL")
                tableColumn.width = self.view.frame.size.width - PacketsViewController.statusColumnWidth - PacketsViewController.dateColumnWidth - PacketsViewController.methodColumnWidth
            case "date":
                tableColumn.headerCell = FlatTableHeaderCell(textCell: "Date")
                tableColumn.width = PacketsViewController.dateColumnWidth
            default:
                break
            }
        }
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        self.viewModel?.clearPackets()
    }
    
}

extension PacketsViewController: NSTableViewDelegate, NSTableViewDataSource
{
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return self.viewModel?.itemCount() ?? 0
    }
    
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        
        return FlatTableRowView()
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if (tableColumn?.identifier)!.rawValue == "statusCode" {
            
            let cell: StatusPacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
            
        }else if (tableColumn?.identifier)!.rawValue == "method" {
            
            let cell: MethodPacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
            
        }else if (tableColumn?.identifier)!.rawValue == "url" {
            
            let cell: URLPacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
            
        }else if (tableColumn?.identifier)!.rawValue == "date" {
            
            let cell: DatePacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        let selectedRow = self.tableView.selectedRow
        
        if selectedRow >= 0 , let item = self.viewModel?.item(at: selectedRow) {
            
            if item !== self.viewModel?.selectedItem {
                
                self.onPacketSelect?(item)
            }
        }else {
            
            self.onPacketSelect?(nil)
        }
    }
    
}


extension PacketsViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        viewModel?.filterTerm = filterTextField.stringValue
    }
    
}


extension PacketsViewController {
    
    func isScrolledToBottom() -> Bool {
        return tableView.enclosingScrollView?.verticalScroller?.floatValue ?? 0 > 0.9
    }
    
    func scrollToBottom() {
        tableView.scrollToEndOfDocument(nil)
    }
    
}
