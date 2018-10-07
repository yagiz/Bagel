//
//  NSView+ThemeKit.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 22/09/2016.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

extension NSView {

    /// Returns the first subview that matches specified class.
    @objc func deepSubview(withClassName className: String) -> NSView? {

        // search level below (view subviews)
        for subview: NSView in self.subviews where subview.className == className {
            return subview
        }

        // search deeper
        for subview: NSView in self.subviews {
            if let foundView = subview.deepSubview(withClassName: className) {
                return foundView
            }
        }

        return nil
    }

}
