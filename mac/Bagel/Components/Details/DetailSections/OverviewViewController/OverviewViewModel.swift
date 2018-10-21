//
//  OverviewViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class OverviewViewModel: BaseViewModel {

    var packet: BagelPacket?
    var contentRepresentation: ContentRepresentation?
    var overviewText: String?
    
    func register() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didSelectPacket), name: BagelNotifications.didSelectPacket, object: nil)
    }
    
    @objc func didSelectPacket() {
        
        self.packet = BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
        
        var overviewString = ""
        
        overviewString = overviewString + (self.packet?.requestInfo?.requestMethod ?? "")
        overviewString = overviewString + " "
        overviewString = overviewString + (self.packet?.requestInfo?.url ?? "")
        
        overviewString = overviewString + "\n\n"
        
        overviewString = overviewString + "Response Code: "
        overviewString = overviewString + (self.packet?.requestInfo?.statusCode ?? "")
        
        if let requestURLString = self.packet?.requestInfo?.url, let requestURL = URL(string: requestURLString) {
            
            let contentRawString = (ContentRepresentationParser.parseURL(url: requestURL).rawString ?? "")
            
            if contentRawString.count > 0 {
                
                overviewString = overviewString + "\n\n"
                overviewString = overviewString + "URL Parameters:\n"
                overviewString = overviewString + contentRawString
            }
        }
        
        if let requestHeaders = self.packet?.requestInfo?.requestHeaders {
            
            let contentRawString = ContentRepresentationParser.parseDictionary(dictionary: requestHeaders).rawString ?? ""
            
            if contentRawString.count > 0 {
                
                overviewString = overviewString + "\n\n"
                overviewString = overviewString + "Request Headers:\n"
                overviewString = overviewString + contentRawString
            }
        }
        
        if let requestBodyData = self.packet?.requestInfo?.requestBody?.base64Data {

            let contentRawString = ContentRepresentationParser.parseData(data: requestBodyData)?.rawString ?? ""
            
            if contentRawString.count > 0 {
                
                overviewString = overviewString + "\n\n"
                overviewString = overviewString + "Request Body:\n"
                overviewString = overviewString + contentRawString
            }
        }
        
        if let responseBodyData = self.packet?.requestInfo?.requestBody?.base64Data {
            
            let contentRawString = ContentRepresentationParser.parseData(data: responseBodyData)?.rawString ?? ""
            
            if contentRawString.count > 0 {
                
                overviewString = overviewString + "\n\n"
                overviewString = overviewString + "Response Body:\n"
                overviewString = overviewString + contentRawString
            }
            
        }
        
        self.overviewText = overviewString
        self.onChange?()
    }
}
