//
//  OverviewRepresentation.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 21.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class OverviewRepresentation: ContentRepresentation  {

    init(requestInfo: BagelRequestInfo?) {
        
        super.init()

        if let requestInfo = requestInfo {
            
            var overviewString = ""
            
            overviewString = overviewString + (requestInfo.requestMethod ?? "")
            overviewString = overviewString + " "
            overviewString = overviewString + (requestInfo.url ?? "")
            
            overviewString = overviewString + "\n\n"
            
            overviewString = overviewString + "Response Code: "
            overviewString = overviewString + (requestInfo.statusCode ?? "")
            
            if let requestURLString = requestInfo.url, let requestURL = URL(string: requestURLString) {
                
                let contentRawString = (ContentRepresentationParser.keyValueRepresentation(url: requestURL).rawString ?? "")
                
                if contentRawString.count > 0 {
                    
                    overviewString = overviewString + "\n\n"
                    overviewString = overviewString + "URL Parameters:\n"
                    overviewString = overviewString + contentRawString
                }
            }
            
            if let requestHeaders = requestInfo.requestHeaders {
                
                let contentRawString = ContentRepresentationParser.keyValueRepresentation(dictionary: requestHeaders).rawString ?? ""
                
                if contentRawString.count > 0 {
                    
                    overviewString = overviewString + "\n\n"
                    overviewString = overviewString + "Request Headers:\n"
                    overviewString = overviewString + contentRawString
                }
            }
            
            if let requestBodyData = requestInfo.requestBody?.base64Data {
                
                let contentRawString = ContentRepresentationParser.dataRepresentation(data: requestBodyData)?.rawString ?? ""
                
                if contentRawString.count > 0 {
                    
                    overviewString = overviewString + "\n\n"
                    overviewString = overviewString + "Request Body:\n"
                    overviewString = overviewString + contentRawString
                }
            }
            
            if let responseBodyData = requestInfo.responseData?.base64Data {
                
                let contentRawString = ContentRepresentationParser.dataRepresentation(data: responseBodyData)?.rawString ?? ""
                
                if contentRawString.count > 0 {
                    
                    overviewString = overviewString + "\n\n"
                    overviewString = overviewString + "Response Body:\n"
                    overviewString = overviewString + contentRawString
                }
                
            }
            
            self.rawString = overviewString
        }
    }
}
