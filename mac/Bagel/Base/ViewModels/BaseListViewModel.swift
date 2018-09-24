//
//  BaseListViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BaseListViewModel<T>: BaseViewModel {

    var items = [T]()
    
    func set(items: [T])
    {
        self.items = items
        self.onChange?()
    }
    
    func itemCount() -> Int
    {
        return self.items.count
    }
    
    func item(at: Int) -> T?
    {
        return self.items[at]
    }
    
}
