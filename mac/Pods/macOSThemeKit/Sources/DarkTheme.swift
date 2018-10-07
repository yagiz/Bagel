//
//  DarkTheme.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 06/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

/// Dark theme.
@objc(TKDarkTheme)
public class DarkTheme: NSObject, Theme {

    /// Dark theme identifier (static).
    @objc public static var identifier: String = "com.luckymarmot.ThemeKit.DarkTheme"

    /// Unique theme identifier.
    public var identifier: String = DarkTheme.identifier

    /// Theme display name.
    public var displayName: String = "Dark Theme"

    /// Theme short display name.
    public var shortDisplayName: String = "Dark"

    /// Is this a dark theme?
    public var isDarkTheme: Bool = true

    /// Calling `init()` is not allowed outside this library.
    /// Use `ThemeManager.darkTheme` instead.
    internal override init() {
        super.init()
    }

    override public var description: String {
        return "<\(DarkTheme.self): \(themeDescription(self))>"
    }
}
