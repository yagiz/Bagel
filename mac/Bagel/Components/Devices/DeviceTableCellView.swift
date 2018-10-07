//
//  DeviceTableCellView.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa
import macOSThemeKit

class DeviceTableCellView: NSTableCellView {

    @IBOutlet weak var backgroundBox: NSBox!
    @IBOutlet weak var deviceNameTextField: NSTextField!
    @IBOutlet weak var deviceDescriptionTextField: NSTextField!
    
    var device: BagelDeviceController!
    {
        didSet
        {
            self.refresh()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundBox.fillColor = ThemeColor.deviceRowSelectedColor
    }
    
    func refresh() {
        
        self.deviceNameTextField.stringValue = self.device.deviceName ?? ""
        self.deviceDescriptionTextField.stringValue = self.device.deviceDescription ?? ""
    }
    
}
