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
    @IBAction func newLogFile(_ sender: NSButton) {
        guard let packets = BagelController.shared.selectedProjectController?.selectedDeviceController?.packets else {return}
        var exportString = ""
        var fileName = "project.log"
        for packet in packets {
            if let requestInfo = packet.requestInfo,
               let rawString = OverviewRepresentation(requestInfo: requestInfo, showResponseHeaders: true).rawString {
                exportString = exportString + rawString + "\n\n"
            }
            if let projectName = BagelController.shared.selectedProjectController?.projectName,
               let devicename = BagelController.shared.selectedProjectController?.selectedDeviceController?.deviceName {
                fileName = "\(projectName)-\(devicename)-\(Date().readableLog).log"
            }
        }
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            try Data(exportString.utf8).write(to: documentDirectory.appendingPathComponent(fileName))
            showAlert(style: .informational, title: "Log file exported!", message:"Log file exported to your documents directory")
        } catch {
            showAlert(style: .warning, title: "Error", message:"An error occurred while trying to save the log file to your documents directory")
        }
    }
    
    private func showAlert(style: NSAlert.Style, title: String, message: String){
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = style
        alert.runModal()
    }
}
