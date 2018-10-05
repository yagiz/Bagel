//
//  DevicesViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DevicesViewController: BaseViewController, NSTableViewDelegate, NSTableViewDataSource {

    var viewModel: DevicesViewModel?
    var onDeviceSelect : ((BagelDeviceController) -> ())?
    
    @IBOutlet weak var tableView: BaseTableView!
    
    override func setup() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel?.onChange = { [weak self] in
            
            self?.refresh()
        }
        
    }
    
    func refresh() {
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension DevicesViewController
{
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return self.viewModel?.itemCount() ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell: DeviceTableCellView = self.tableView.makeView(withOwner: nil)!
        cell.device = self.viewModel?.item(at: row)
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        let selectedRow = self.tableView.selectedRow
        
        if selectedRow >= 0, let item = self.viewModel?.item(at: selectedRow) {
            
            self.onDeviceSelect?(item)
        }
    }
}
