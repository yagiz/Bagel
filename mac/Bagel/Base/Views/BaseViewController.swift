//
//  BaseViewController.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 30/08/2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setup()
    }
    
    static var identifier: NSStoryboard.SceneIdentifier {
        
        return NSStoryboard.SceneIdentifier(String(describing: self))
    }
    
    func setup() {
        
    }
}
