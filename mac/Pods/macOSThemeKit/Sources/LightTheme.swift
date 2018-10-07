//
//  LightTheme.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 06/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

/// Light theme (default).
@objc(TKLightTheme)
public class LightTheme: NSObject, Theme {

    /// Light theme identifier (static).
    @objc public static var identifier: String = "com.luckymarmot.ThemeKit.LightTheme"

    /// Unique theme identifier.
    public var identifier: String = LightTheme.identifier

    /// Theme display name.
    public var displayName: String = "Light Theme"

    /// Theme short display name.
    public var shortDisplayName: String = "Light"

    /// Is this a dark theme?
    public var isDarkTheme: Bool = false

    /// Calling `init()` is not allowed outside this library.
    /// Use `ThemeManager.lightTheme` instead.
    internal override init() {
        super.init()
    }

    override public var description: String {
        return "<\(LightTheme.self): \(themeDescription(self))>"
    }
}
