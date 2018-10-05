//
//  DataJSONViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 2.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class DataJSONViewModel: BaseViewModel {
    
    var currentJSONString: String?
    
    func parse(data: Data?) -> String? {
        
        guard let data = data else { return nil }

        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    
                    self.currentJSONString = jsonString
                    self.onChange?()
                    
                    return self.currentJSONString
                }
            }
        }
        
        return nil
    }
}
