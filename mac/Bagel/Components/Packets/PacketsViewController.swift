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
    
    struct TableIdentifiers {
        static let statusCode = "statusCode"
        static let method = "method"
        static let url = "url"
        static let date = "date"
    }
    
    enum FilterTags: Int {
        case address, status, method
    }
    
    static var statusColumnWidth = CGFloat(50.0)
    static var methodColumnWidth = CGFloat(55.0)
    static var dateColumnWidth = CGFloat(150.0)
    
    var viewModel: PacketsViewModel?
    var onPacketSelect : ((BagelPacket?) -> ())?
    
    @IBOutlet weak var clearButton: NSButton!
    @IBOutlet weak var tableView: BaseTableView!
    
    @IBOutlet weak var addressFilterTextField: NSTextField!
    @IBOutlet weak var statusFilterTextField: NSTextField!
    @IBOutlet weak var methodFilterTextField: NSTextField!
    
    override func setup() {
        
        self.clearButton.image = ThemeImage.clearIcon
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = ThemeColor.controlBackgroundColor
        self.tableView.gridColor = ThemeColor.gridColor
        
        setupFilterTextFields()
        
        self.viewModel?.onChange = { [weak self] in
            self?.refresh()
        }
        
        self.setupTableViewHeaders()
    }
    
    private func setupFilterTextFields() {
        self.addressFilterTextField.backgroundColor = ThemeColor.controlBackgroundColor
        self.addressFilterTextField.tag = FilterTags.address.rawValue
        self.addressFilterTextField.delegate = self
        
        self.statusFilterTextField.backgroundColor = ThemeColor.controlBackgroundColor
        self.statusFilterTextField.tag = FilterTags.status.rawValue
        self.statusFilterTextField.delegate = self
        
        self.methodFilterTextField.backgroundColor = ThemeColor.controlBackgroundColor
        self.methodFilterTextField.tag = FilterTags.method.rawValue
        self.methodFilterTextField.delegate = self
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
            case TableIdentifiers.statusCode:
                tableColumn.headerCell = FlatTableHeaderCell(textCell: "Status")
                tableColumn.width = PacketsViewController.statusColumnWidth
            case TableIdentifiers.method:
                tableColumn.headerCell = FlatTableHeaderCell(textCell: "Method")
                tableColumn.width = PacketsViewController.methodColumnWidth
            case TableIdentifiers.url:
                tableColumn.headerCell = FlatTableHeaderCell(textCell: "URL")
                tableColumn.width = self.view.frame.size.width - PacketsViewController.statusColumnWidth - PacketsViewController.dateColumnWidth - PacketsViewController.methodColumnWidth
            case TableIdentifiers.date:
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

extension PacketsViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.viewModel?.itemCount() ?? 0
    }
    
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return FlatTableRowView()
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier.rawValue else { return nil }
        
        switch identifier  {
        case TableIdentifiers.statusCode:
            let cell: StatusPacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
        case TableIdentifiers.method:
            let cell: MethodPacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
        case TableIdentifiers.url:
            let cell: URLPacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
        case TableIdentifiers.date:
            let cell: DatePacketTableCellView = self.tableView.makeView(withOwner: nil)!
            cell.packet = self.viewModel?.item(at: row)
            cell.backgroundStyle = .normal
            return cell
        default:
            return nil
        }
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = self.tableView.selectedRow
        
        guard selectedRow >= 0, let item = self.viewModel?.item(at: selectedRow) else {
            self.onPacketSelect?(nil)
            return
        }
        
        guard item !== self.viewModel?.selectedItem else { return }
        self.onPacketSelect?(item)
    }
    
}


extension PacketsViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let tag = (obj.object as? NSTextField)?.tag else { return }
        guard let filterTag = FilterTags(rawValue: tag) else { return }
        
        switch filterTag {
        case .address:
            viewModel?.addressFilterTerm = addressFilterTextField.stringValue
        case .method:
            viewModel?.methodFilterTerm = methodFilterTextField.stringValue
        case .status:
            viewModel?.statusFilterTerm = statusFilterTextField.stringValue
        }

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
