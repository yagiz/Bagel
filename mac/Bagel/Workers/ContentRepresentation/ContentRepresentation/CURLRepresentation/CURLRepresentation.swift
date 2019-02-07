//
//  CURLRepresentation.swift
//  Bagel
//
//  Created by Mathias Amnell on 2019-01-23.
//  Copyright © 2019 Yagiz Lab. All rights reserved.
//

import Cocoa

class CURLRepresentation: ContentRepresentation  {

    init(requestInfo: BagelRequestInfo?) {

        super.init()

        if let requestInfo = requestInfo {
            self.rawString = requestInfo.curlString
        }
    }
}

extension BagelRequestInfo {
    // Credits to shaps80
    // https://gist.github.com/shaps80/ba6a1e2d477af0383e8f19b87f53661d
    fileprivate var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url)"

        if requestMethod == .head {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = self.requestMethod, method != .get && method != .head {
            command.append("-X \(method)")
        }

        if let headers = requestHeaders {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = requestBody {
            command.append("-d '\(data)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}
