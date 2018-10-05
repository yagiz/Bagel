//
//  RequestParametersViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class RequestParametersViewModel: KeyValueViewModel {

    override func didSelectPacket() {
        
        super.didSelectPacket()
        
        self.items = [KeyValue]()
        self.items.append(contentsOf: self.getURLParameters())
            
        self.onChange?()
    }
    
    func getURLParameters() -> [KeyValue] {
        
        var parameters = [KeyValue]()
        
        if let url = URL(string: self.packet?.requestInfo?.url ?? "") {
            
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                
                for queryItem in queryItems {
                    
                    parameters.append([queryItem.name : queryItem.value ?? ""])
                    
                }
            }
        }
        
        return parameters
    }

}
