//
//  NSColor+ThemeKit.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 24/09/2016.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

/**
 `NSColor` ThemeKit extension to help on when overriding colors in `ThemeColor` extensions.
 */
extension NSColor {

    // MARK: -
    // MARK: Color override

    /// Swizzle NSColor in case we are replacing system colors by themable colors.
    @objc static func swizzleNSColor() {
        swizzleNSColorOnce
    }

    /// Swizzle NSColor in case we are replacing system colors by themable colors.
    /// This code is executed *only once* (even if invoked multiple times).
    private static let swizzleNSColorOnce: Void = {
        // swizzle only if needed
        guard needsSwizzling else { return }

        // swizzle NSColor methods
        swizzleInstanceMethod(cls: NSClassFromString("NSDynamicSystemColor"), selector: #selector(set), withSelector: #selector(themeKitSet))
        swizzleInstanceMethod(cls: NSClassFromString("NSDynamicSystemColor"), selector: #selector(setFill), withSelector: #selector(themeKitSetFill))
        swizzleInstanceMethod(cls: NSClassFromString("NSDynamicSystemColor"), selector: #selector(setStroke), withSelector: #selector(themeKitSetStroke))
    }()

    /// Check if color is being overriden in a ThemeColor extension.
    @objc public var isThemeOverriden: Bool {

        // check if `NSColor` provides this color
        let selector = Selector(colorNameComponent.rawValue)
        let nsColorMethod = class_getClassMethod(NSColor.classForCoder(), selector)
        guard nsColorMethod != nil else {
            return false
        }

        // get current theme
        let theme = ThemeManager.shared.effectiveTheme

        // `UserTheme`: check `hasThemeAsset(_:)` method
        if let userTheme = theme as? UserTheme {
            return userTheme.hasThemeAsset(colorNameComponent.rawValue)
        }

        // native themes: look up for an instance method
        else {
            let themeClass: AnyClass = object_getClass(theme)!
            let themeColorMethod = class_getInstanceMethod(themeClass, selector)
            return themeColorMethod != nil && nsColorMethod != themeColorMethod
        }
    }

    /// Get all `NSColor` color methods.
    /// Overridable class methods (can be overriden in `ThemeColor` extension).
    @objc public class func colorMethodNames() -> [String] {
        let nsColorMethods = NSObject.classMethodNames(for: NSColor.classForCoder()).filter { (methodName) -> Bool in
            return methodName.hasSuffix("Color")
        }
        return nsColorMethods
    }

    // MARK: - Private

    /// Check if we need to swizzle NSDynamicSystemColor class.
    private class var needsSwizzling: Bool {
        let themeColorMethods = classMethodNames(for: ThemeColor.classForCoder()).filter { (methodName) -> Bool in
            return methodName.hasSuffix("Color")
        }
        let nsColorMethods = classMethodNames(for: NSColor.classForCoder()).filter { (methodName) -> Bool in
            return methodName.hasSuffix("Color")
        }

        // checks if NSColor `*Color` class methods are being overriden
        for colorMethod in themeColorMethods {
            if nsColorMethods.contains(colorMethod) {
                // theme color with `colorMethod` selector is overriding a `NSColor` method -> swizzling needed.
                return true
            }
        }

        return false
    }

    // ThemeKit.set() replacement to use theme-aware color
    @objc public func themeKitSet() {
        // call original .set() function
        themeKitSet()

        // check if the user provides an alternative color
        if isThemeOverriden {
            // call ThemeColor.set() function
            ThemeColor.color(with: Selector(colorNameComponent.rawValue)).set()
        }
    }

    // ThemeKit.setFill() replacement to use theme-aware color
    @objc public func themeKitSetFill() {
        // call original .setFill() function
        themeKitSetFill()

        // check if the user provides an alternative color
        if isThemeOverriden {
            // call ThemeColor.setFill() function
            ThemeColor.color(with: Selector(colorNameComponent.rawValue)).setFill()
        }
    }

    // ThemeKit.setStroke() replacement to use theme-aware color
    @objc public func themeKitSetStroke() {
        // call original .setStroke() function
        themeKitSetStroke()

        // check if the user provides an alternative color
        if isThemeOverriden {
            // call ThemeColor.setStroke() function
            ThemeColor.color(with: Selector(colorNameComponent.rawValue)).setStroke()
        }
    }

}
