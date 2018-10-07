//
//  NotificationName+ThemeKit.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 07/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

/**
 Notifications defined by `ThemeKit`.
 */
public extension Notification.Name {

    /// ThemeKit notification sent when current theme is about to change.
    public static let willChangeTheme = Notification.Name("ThemeKitWillChangeThemeNotification")

    /// ThemeKit notification sent when current theme did change.
    public static let didChangeTheme = Notification.Name("ThemeKitDidChangeThemeNotification")

    /// ThemeKit notification sent when system theme did change (System Preference > General > Appearance).
    public static let didChangeSystemTheme = Notification.Name("ThemeKitDidChangeSystemThemeNotification")

    /// Convenience property for the system notification sent when System Preference for dark mode changes.
    static let didChangeAppleInterfaceTheme = Notification.Name("AppleInterfaceThemeChangedNotification")
}
