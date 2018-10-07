//
//  ThemeGradient.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 07/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

private var _cachedGradients: NSCache<NSNumber, ThemeGradient> = NSCache()
private var _cachedThemeGradients: NSCache<NSNumber, NSGradient> = NSCache()

/**
 `ThemeGradient` is a `NSGradient` subclass that dynamically changes its colors 
 whenever a new theme is make current.
 
 Theme-aware means you don't need to check any conditions when choosing which
 gradient to draw. E.g.:
 
 ```
 ThemeGradient.rainbowGradient.draw(in: bounds, angle: 0)
 ```
 
 The drawing code will draw with different gradient depending on the selected 
 theme. Unless some drawing cache is being done, there's no need to refresh the
 UI after changing the current theme.
 
 Defining theme-aware gradients
 ------------------------------
 
 The recommended way of adding your own dynamic gradients is as follows:
 
 1. **Add a `ThemeGradient` class extension** (or `TKThemeGradient` category on
 Objective-C) to add class methods for your gradients. E.g.:
 
     In Swift:
 
     ```
     extension ThemeGradient {
     
         static var brandGradient: ThemeGradient {
            return ThemeGradient.gradient(with: #function)
         }
     
     }
     ```
 
     In Objective-C:
 
     ```
     @interface TKThemeGradient (Demo)
     
     + (TKThemeGradient*)brandGradient;
     
     @end
     
     @implementation TKThemeGradient (Demo)
     
     + (TKThemeGradient*)brandGradient {
        return [TKThemeGradient gradientWithSelector:_cmd];
     }
     
     @end
     ```
 
 2. **Add Class Extensions on any `Theme` you want to support** (e.g., `LightTheme`
 and `DarkTheme` - `TKLightTheme` and `TKDarkTheme` on Objective-C) to provide
 instance methods for each theme gradient class method defined on (1). E.g.:
 
     In Swift:
 
     ```
     extension LightTheme {
     
         var brandGradient: NSGradient {
            return NSGradient(starting: NSColor.white, ending: NSColor.black)
         }
         
         }
         
         extension DarkTheme {
         
         var brandGradient: NSGradient {
            return NSGradient(starting: NSColor.black, ending: NSColor.white)
         }
     
     }
     ```
 
     In Objective-C:
 
     ```
     @interface TKLightTheme (Demo) @end
     
     @implementation TKLightTheme (Demo)
     
     - (NSGradient*)brandGradient
     {
        return [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] endingColor:[NSColor blackColor]];
     }
     
     @end
     
     @interface TKDarkTheme (Demo) @end
     
     @implementation TKDarkTheme (Demo)
     
     - (NSGradient*)brandGradient
     {
        return [[NSGradient alloc] initWithStartingColor:[NSColor blackColor] endingColor:[NSColor whiteColor]];
     }
     
     @end
     ```
 
 3.  If supporting `UserTheme`'s, **define properties on user theme files** (`.theme`)
 for each theme gradient class method defined on (1). E.g.:
 
     ```
     displayName = Sample User Theme
     identifier = com.luckymarmot.ThemeKit.SampleUserTheme
     darkTheme = false
     
     orangeSky = rgb(160, 90, 45, .5)
     brandGradient = linear-gradient($orangeSky, rgb(200, 140, 60))
     ```
 
 Fallback colors
 ---------------
 Unimplemented properties/methods on target theme class will default to
 `fallbackGradient`. This too, can be customized per theme.
 
 Please check `ThemeColor` for theme-aware colors and `ThemeImage` for theme-aware images.
 */
@objc(TKThemeGradient)
open class ThemeGradient: NSGradient {

    // MARK: -
    // MARK: Properties

    /// `ThemeGradient` gradient selector used as theme instance method for same
    /// selector or, if inexistent, as argument in the theme instance method `themeAsset(_:)`.
    @objc public var themeGradientSelector: Selector? {
        didSet {
            // recache gradient now and on theme change
            recacheGradient()
            registerThemeChangeNotifications()
        }
    }

    /// Resolved gradient from current theme (dynamically changes with the current theme).
    @objc public var resolvedThemeGradient: NSGradient?

    // MARK: -
    // MARK: Creating Gradients

    /// Create a new ThemeGradient instance for the specified selector.
    ///
    /// - parameter selector: Selector for color method.
    ///
    /// - returns: A `ThemeGradient` instance for the specified selector.
    @objc(gradientWithSelector:)
    public class func gradient(with selector: Selector) -> ThemeGradient? {
        let cacheKey = CacheKey(selector: selector)

        if let cachedGradient = _cachedGradients.object(forKey: cacheKey) {
            return cachedGradient
        } else if let gradient = ThemeGradient(with: selector) {
            _cachedGradients.setObject(gradient, forKey: cacheKey)
            return gradient
        }
        return nil
    }

    /// Gradient for a specific theme.
    ///
    /// - parameter theme:    A `Theme` instance.
    /// - parameter selector: A gradient selector.
    ///
    /// - returns: Resolved gradient for specified selector on given theme.
    @objc(gradientForTheme:selector:)
    public class func gradient(for theme: Theme, selector: Selector) -> NSGradient? {
        let cacheKey = CacheKey(selector: selector, theme: theme)
        var gradient = _cachedThemeGradients.object(forKey: cacheKey)

        if gradient == nil {
            // Theme provides this asset?
            gradient = theme.themeAsset(NSStringFromSelector(selector)) as? NSGradient

            // Otherwise, use fallback gradient
            if gradient == nil {
                gradient = fallbackGradient(for: theme, selector: selector)
            }

            // Cache it
            if let themeGradient = gradient {
                _cachedThemeGradients.setObject(themeGradient, forKey: cacheKey)
            }
        }

        return gradient
    }

    /// Current theme gradient, but respecting view appearance and any window
    /// specific theme (if set).
    ///
    /// If a `NSWindow.windowTheme` was set, it will be used instead.
    /// Some views may be using a different appearance than the theme appearance.
    /// In thoses cases, gradient won't be resolved using current theme, but from
    /// either `lightTheme` or `darkTheme`, depending of whether view appearance
    /// is light or dark, respectively.
    ///
    /// - parameter view:     A `NSView` instance.
    /// - parameter selector: A gradient selector.
    ///
    /// - returns: Resolved gradient for specified selector on given view.
    @objc(gradientForView:selector:)
    public class func gradient(for view: NSView, selector: Selector) -> NSGradient? {
        // if a custom window theme was set, use the appropriate asset
        if let windowTheme = view.window?.windowTheme {
            return ThemeGradient.gradient(for: windowTheme, selector: selector)
        }

        let theme = ThemeManager.shared.effectiveTheme
        let viewAppearance = view.appearance
        let aquaAppearance = NSAppearance(named: NSAppearance.Name.aqua)
        let lightAppearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
        let darkAppearance = NSAppearance(named: NSAppearance.Name.vibrantDark)

        // using a dark theme but control is on a light surface => use light theme instead
        if theme.isDarkTheme &&
            (viewAppearance == lightAppearance || viewAppearance == aquaAppearance) {
            return ThemeGradient.gradient(for: ThemeManager.lightTheme, selector: selector)
        } else if theme.isLightTheme && viewAppearance == darkAppearance {
            return ThemeGradient.gradient(for: ThemeManager.darkTheme, selector: selector)
        }

        // otherwise, return current theme gradient
        return ThemeGradient.gradient(with: selector)
    }

    /// Returns a new `ThemeGradient` for the given selector.
    ///
    /// - parameter selector:   A gradient selector.
    ///
    /// - returns: A `ThemeGradient` instance.
    @objc init?(with selector: Selector) {
        // initialize properties
        themeGradientSelector = selector
        let defaultColor = ThemeManager.shared.effectiveTheme.defaultFallbackBackgroundColor
        resolvedThemeGradient = NSGradient(starting: defaultColor, ending: defaultColor)

        super.init(colors: [defaultColor, defaultColor], atLocations: [0.0, 1.0], colorSpace: NSColorSpace.genericRGB)

        // cache gradient
        recacheGradient()

        // recache on theme change
        registerThemeChangeNotifications()
    }

    required public init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeTheme, object: nil)
    }

    /// Register to recache on theme changes.
    @objc func registerThemeChangeNotifications() {
        NotificationCenter.default.removeObserver(self, name: .didChangeTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recacheGradient), name: .didChangeTheme, object: nil)
    }

    /// Forces dynamic gradient resolution into `resolvedThemeGradient` and cache it.
    /// You should not need to manually call this function.
    @objc open func recacheGradient() {
        // If it is a UserTheme we actually want to discard theme cached values
        if ThemeManager.shared.effectiveTheme.isUserTheme {
            ThemeGradient.emptyCache()
        }

        // Recache resolved color
        if let selector = themeGradientSelector,
            let newGradient = ThemeGradient.gradient(for: ThemeManager.shared.effectiveTheme, selector: selector) {
            resolvedThemeGradient = newGradient
        }
    }

    /// Clear all caches.
    /// You should not need to manually call this function.
    @objc static open func emptyCache() {
        _cachedGradients.removeAllObjects()
        _cachedThemeGradients.removeAllObjects()
    }

    /// Fallback gradient for a specific theme and selector.
    @objc class func fallbackGradient(for theme: Theme, selector: Selector) -> NSGradient? {
        var fallbackGradient: NSGradient?

        // try with theme provided `fallbackGradient` method
        if let themeFallbackGradient = theme.fallbackGradient as? NSGradient {
            fallbackGradient = themeFallbackGradient
        }
        // try with theme asset `fallbackGradient`
        if fallbackGradient == nil, let themeAsset = theme.themeAsset("fallbackGradient") as? NSGradient {
            fallbackGradient = themeAsset
        }
        // otherwise just use default fallback gradient
        return fallbackGradient ?? theme.defaultFallbackGradient
    }

    // MARK: - NSGradient Overrides

    override open func draw(in rect: NSRect, angle: CGFloat) {
        resolvedThemeGradient?.draw(in: rect, angle: angle)
    }

    override open func draw(in path: NSBezierPath, angle: CGFloat) {
        resolvedThemeGradient?.draw(in: path, angle: angle)
    }

    override open func draw(from startingPoint: NSPoint, to endingPoint: NSPoint, options: NSGradient.DrawingOptions = []) {
        resolvedThemeGradient?.draw(from: startingPoint, to: endingPoint, options: options)
    }

    override open func draw(fromCenter startCenter: NSPoint, radius startRadius: CGFloat, toCenter endCenter: NSPoint, radius endRadius: CGFloat, options: NSGradient.DrawingOptions = []) {
        resolvedThemeGradient?.draw(fromCenter: startCenter, radius: startRadius, toCenter: endCenter, radius: endRadius, options: options)
    }

    override open func draw(in rect: NSRect, relativeCenterPosition: NSPoint) {
        resolvedThemeGradient?.draw(in: rect, relativeCenterPosition: relativeCenterPosition)
    }

    override open func draw(in path: NSBezierPath, relativeCenterPosition: NSPoint) {
        resolvedThemeGradient?.draw(in: path, relativeCenterPosition: relativeCenterPosition)
    }

    override open var colorSpace: NSColorSpace {
        return resolvedThemeGradient?.colorSpace ?? .genericRGB
    }

    override open var numberOfColorStops: Int {
        return resolvedThemeGradient?.numberOfColorStops ?? 0
    }

    override open func getColor(_ color: AutoreleasingUnsafeMutablePointer<NSColor>?, location: UnsafeMutablePointer<CGFloat>?, at index: Int) {
        resolvedThemeGradient?.getColor(color, location: location, at: index)
    }

    override open func interpolatedColor(atLocation location: CGFloat) -> NSColor {
        return resolvedThemeGradient?.interpolatedColor(atLocation: location) ?? NSColor.clear
    }
}
