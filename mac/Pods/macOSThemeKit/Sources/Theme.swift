//
//  Theme.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 06/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

/**
 Theme protocol: the base of all themes.
 
 *ThemeKit* makes available, without any further coding:
 
 - a `LightTheme` (the default macOS theme)
 - a `DarkTheme` (the dark macOS theme, using `NSAppearanceNameVibrantDark`)
 - a `SystemTheme` (which dynamically resolve to either `LightTheme` or `DarkTheme 
   depending on the macOS preference at **System Preferences > General > Appearance**)
 
 You can choose wheter or not to use these, and you can also implement your custom
 themes by:
 
 - implementing native `Theme` classes conforming to this protocol and `NSObject`
 - provide user themes (`UserTheme`) with `.theme` files
 
 Please check the provided *Demo.app* project for sample implementations of both.
 
 */
@objc(TKTheme)
public protocol Theme: NSObjectProtocol {
    // MARK: Required Properties

    /// Unique theme identifier.
    var identifier: String { get }

    /// Theme display name.
    var displayName: String { get }

    /// Theme short display name.
    var shortDisplayName: String { get }

    /// Is this a dark theme?
    var isDarkTheme: Bool { get }

    // MARK: Optional Methods/Properties

    /// Optional: foreground color to be used on when a foreground color is not provided
    /// by the theme.
    @objc optional var fallbackForegroundColor: NSColor? { get }

    /// Optional: background color to be used on when a background color (a color which
    /// contains `Background` in its name) is not provided by the theme.
    @objc optional var fallbackBackgroundColor: NSColor? { get }

    /// Optional: gradient to be used on when a gradient is not provided by the theme.
    @objc optional var fallbackGradient: NSGradient? { get }

    /// Optional: image to be used on when an image is not provided by the theme.
    @objc optional var fallbackImage: NSImage? { get }
}

/// Theme protocol extension.
///
/// These functions are available for all `Theme`s.
public extension Theme {

    // MARK: Convenient Methods/Properties (Swift only)

    /// Is this a light theme?
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// !aTheme.isDarkTheme
    /// ```
    public var isLightTheme: Bool {
        return !isDarkTheme
    }

    /// Is this the system theme? If true, theme automatically resolve to
    /// `ThemeManager.lightTheme` or `ThemeManager.darkTheme`, accordingly to
    /// **System Preferences > General > Appearance**.
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// [aTheme.identifier isEqualToString:TKSystemTheme.identifier]
    /// ```
    public var isSystemTheme: Bool {
        return identifier == SystemTheme.identifier
    }

    /// Is this a user theme?
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// [aTheme isKindOfClass:[TKUserTheme class]]
    /// ```
    public var isUserTheme: Bool {
        return self is UserTheme
    }

    /// Apply theme (make it the current one).
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// [[TKThemeManager sharedManager] setTheme:aTheme]
    /// ```
    public func apply() {
        ThemeManager.shared.theme = self
    }

    /// Theme asset for the specified key. Supported assets are `NSColor`, `NSGradient`, `NSImage` and `NSString`.
    ///
    /// This function is overriden by `UserTheme`.
    ///
    /// This method is not available from Objective-C.
    ///
    /// - parameter key: A color name, gradient name, image name or a theme string
    ///
    /// - returns: The theme value for the specified key.
    public func themeAsset(_ key: String) -> Any? {
        // Because `Theme` is an @objc protocol, we cannot define this method on
        // the protocol and a provide a default implementation on this extension,
        // plus another on `UserTheme`. This is a workaround to accomplish it.
        if let userTheme = self as? UserTheme {
            return userTheme.themeAsset(key)
        }

        let selector = NSSelectorFromString(key)
        if let theme = self as? NSObject,
            theme.responds(to: selector) {
            return theme.perform(selector).takeUnretainedValue()
        }

        return nil
    }

    /// Checks if a theme asset is provided for the given key.
    ///
    /// This function is overriden by `UserTheme`.
    ///
    /// This method is not available from Objective-C.
    ///
    /// - parameter key: A color name, gradient name, image name or a theme string
    ///
    /// - returns: `true` if theme provides an asset for the given key; `false` otherwise.
    public func hasThemeAsset(_ key: String) -> Bool {
        return themeAsset(key) != nil
    }

    /// Default foreground color to be used on fallback situations when
    /// no `fallbackForegroundColor` was specified by the theme.
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// aTheme.isDarkTheme ? NSColor.whiteColor : NSColor.blackColor
    /// ```
    var defaultFallbackForegroundColor: NSColor {
        return isLightTheme ? NSColor.black : NSColor.white
    }

    /// Default background color to be used on fallback situations when
    /// no `fallbackBackgroundColor` was specified by the theme (background color
    /// is a color method that contains `Background` in its name).
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// aTheme.isDarkTheme ? NSColor.blackColor : NSColor.whiteColor
    /// ```
    var defaultFallbackBackgroundColor: NSColor {
        return isLightTheme ? NSColor.white : NSColor.black
    }

    /// Default gradient to be used on fallback situations when
    /// no `fallbackForegroundColor` was specified by the theme.
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// [[NSGradient alloc] initWithStartingColor:(aTheme.isDarkTheme ? NSColor.blackColor : NSColor.whiteColor) endingColor:(aTheme.isDarkTheme ? NSColor.whiteColor : NSColor.blackColor)]
    /// ```
    var defaultFallbackGradient: NSGradient? {
        return NSGradient(starting: defaultFallbackBackgroundColor, ending: defaultFallbackBackgroundColor)
    }

    /// Default image to be used on fallback situations when
    /// no image was specified by the theme.
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// [[NSImage alloc] initWithSize:NSZeroSize]
    /// ```
    var defaultFallbackImage: NSImage {
        return NSImage(size: NSSize.zero)
    }

    /// Effective theme, which can be different from itself if it represents the 
    /// system theme, respecting **System Preferences > General > Appearance** 
    /// (in that case it will be either `ThemeManager.lightTheme` or `ThemeManager.darkTheme`).
    ///
    /// This method is not available from Objective-C. Alternative code:
    ///
    /// ```objc
    /// [aTheme.identifier isEqualToString:TKSystemTheme.identifier] ? (aTheme.isDarkTheme ? TKThemeManager.darkTheme : TKThemeManager.lightTheme) : aTheme;
    /// ```
    var effectiveTheme: Theme {
        if isSystemTheme {
            return isDarkTheme ? ThemeManager.darkTheme : ThemeManager.lightTheme
        } else {
            return self
        }
    }

    /// Theme description.
    public func themeDescription(_ theme: Theme) -> String {
        return "\"\(displayName)\" [\(identifier)]\(isDarkTheme ? " (Dark)" : "")"
    }
}

/// Check if themes are the same.
func == (lhs: Theme, rhs: Theme) -> Bool {
    return lhs.identifier == rhs.identifier
}

/// Check if themes are different.
func != (lhs: Theme, rhs: Theme) -> Bool {
    return lhs.identifier != rhs.identifier
}
