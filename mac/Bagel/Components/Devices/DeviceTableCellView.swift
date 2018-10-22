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
    var isSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundBox.fillColor = ThemeColor.deviceRowSelectedColor
    }
    
    func refresh() {
        
        self.deviceNameTextField.stringValue = self.device.deviceName ?? ""
        self.deviceDescriptionTextField.stringValue = self.device.deviceDescription ?? ""
        self.backgroundBox.isHidden = !self.isSelected
        
        if self.isSelected {
            
            self.deviceNameTextField.font = FontManager.mainMediumFont(size: 14)
            self.deviceNameTextField.textColor = ThemeColor.textColor
        }else {
            
            self.deviceNameTextField.font = FontManager.mainFont(size: 14)
            self.deviceNameTextField.textColor = ThemeColor.secondaryLabelColor
        }
    }
    
}
