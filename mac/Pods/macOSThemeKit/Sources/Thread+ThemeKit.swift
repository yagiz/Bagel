//
//  Thread+ThemeKit.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 08/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

extension Thread {

    /// Make sure code block is executed on main thread.
    @objc class func onMain(block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }

}
