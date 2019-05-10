//
//  BagelRequestInfo.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 02/09/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

enum RequestMethod: String, Codable {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
  case head = "HEAD"
}

class BagelRequestInfo: Codable {

    var url: String?
    var requestHeaders: [String: String]?
    var requestBody: String?
    var requestMethod: RequestMethod?
    
    var responseHeaders: [String: String]?
    var responseData: String?
    
    var statusCode: String?
    
    var startDate: Date?
    var endDate: Date?
}
