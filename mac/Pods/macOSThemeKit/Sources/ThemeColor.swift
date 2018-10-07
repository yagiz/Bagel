//
//  ThemeColor.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 06/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

private var _cachedColors: NSCache<NSNumber, ThemeColor> = NSCache()
private var _cachedThemeColors: NSCache<NSNumber, NSColor> = NSCache()

/**
 `ThemeColor` is a `NSColor` subclass that dynamically changes its colors whenever
 a new theme is make current.
 
 Theme-aware means you don't need to check any conditions when choosing which 
 color to draw or set on a control. E.g.:
 
 ```
 myTextField.textColor = ThemeColor.myContentTextColor
 
 ThemeColor.myCircleFillColor.setFill()
 NSBezierPath(rect: bounds).fill()
 ```
 
 The text color of `myTextField` will automatically change when the user switches
 a theme. Similarly, the drawing code will draw with different color depending on
 the selected theme. Unless some drawing cache is being done, there's no need to 
 refresh the UI after changing the current theme.
 
 You can also define a color to be a pattern image using `NSColor(patternImage:)`.
 
 Defining theme-aware colors
 ---------------------------
 The recommended way of adding your own dynamic colors is as follows:
 
 1. **Add a `ThemeColor` class extension** (or `TKThemeColor` category on Objective-C)
 to add class methods for your colors. E.g.:
 
     In Swift:
 
     ```swift
     extension ThemeColor {
     
       static var brandColor: ThemeColor { 
         return ThemeColor.color(with: #function)
       }
     
     }
     ```
 
     In Objective-C:
 
     ```objc
     @interface TKThemeColor (Demo)
     
     + (TKThemeColor*)brandColor;
     
     @end
     
     @implementation TKThemeColor (Demo)
     
     + (TKThemeColor*)brandColor {
       return [TKThemeColor colorWithSelector:_cmd];
     }
     
     @end
     ```
 
 2. **Add Class Extensions on any `Theme` you want to support** (e.g., `LightTheme`
 and `DarkTheme` - `TKLightTheme` and `TKDarkTheme` on Objective-C) to provide
 instance methods for each theme color class method defined on (1). E.g.:
    
     In Swift:
 
     ```swift
     extension LightTheme {
     
       var brandColor: NSColor {
         return NSColor.orange
       }
 
     }
 
     extension DarkTheme {
     
       var brandColor: NSColor {
         return NSColor.white
       }
 
     }
     ```
 
     In Objective-C:
 
     ```objc
     @interface TKLightTheme (Demo) @end
     
     @implementation TKLightTheme (Demo)

        - (NSColor*)brandColor
        {
            return [NSColor orangeColor];
        }
 
     @end
 
     @interface TKDarkTheme (Demo) @end
     
     @implementation TKDarkTheme (Demo)

        - (NSColor*)brandColor
        {
            return [NSColor whiteColor];
        }
 
     @end
     ```
 
 3. If supporting `UserTheme`'s, **define properties on user theme files** (`.theme`)
 for each theme color class method defined on (1). E.g.:
 
     ```swift
     displayName = Sample User Theme
     identifier = com.luckymarmot.ThemeKit.SampleUserTheme
     darkTheme = false
 
     brandColor = rgba(96, 240, 12, 0.5)
     ```
 
 Overriding system colors
 ------------------------
 Besides your own colors added as `ThemeColor` class methods, you can also override 
 `NSColor` class methods so that they return theme-aware colors. The procedure is
 exactly the same, so, for example, if adding a method named `labelColor` to a 
 `ThemeColor` extension, that method will be overriden in `NSColor` and the colors
 from `Theme` subclasses will be used instead. 
 In sum, calling `NSColor.labelColor` will return theme-aware colors.
 
 You can get the full list of available/overridable color methods (class methods)
 calling `NSColor.colorMethodNames()`.
 
 At any time, you can check if a system color is being overriden by current theme
 by checking the `NSColor.isThemeOverriden` property (e.g., `NSColor.labelColor.isThemeOverriden`).
 
 When a theme does not override a system color, the original system color will be
 used instead. E.g., you have overrided `ThemeColor.labelColor`, but currently 
 applied theme does not implement `labelColor` -> original `labelColor` will be
 used.
 
 Fallback colors
 ---------------
 With the exception of system overrided named colors, which defaults to the original
 system provided named color when theme does not specifies it, unimplemented
 properties/methods on target theme class will default to `fallbackForegroundColor`
 and `fallbackBackgroundColor`, for foreground and background colors respectively.
 These too, can be customized per theme.
 
 Please check `ThemeGradient` for theme-aware gradients and `ThemeImage` for theme-aware images.
 */
@objc(TKThemeColor)
open class ThemeColor: NSColor {

    // MARK: -
    // MARK: Properties

    /// `ThemeColor` color selector used as theme instance method for same selector
    /// or, if inexistent, as argument in the theme instance method `themeAsset(_:)`.
    @objc public var themeColorSelector: Selector = #selector(getter: NSColor.clear) {
        didSet {
            // recache color now and on theme change
            recacheColor()
            registerThemeChangeNotifications()
        }
    }

    /// Resolved color from current theme (dynamically changes with the current theme).
    @objc public lazy var resolvedThemeColor: NSColor = NSColor.clear

    /// Theme color space (if specified).
    private var themeColorSpace: NSColorSpace? {
        didSet {
            // recache color now and on theme change
            recacheColor()
            registerThemeChangeNotifications()
        }
    }

    /// Average color of pattern image from resolved color (nil for non-pattern image colors)
    private var themePatternImageAverageColor: NSColor = NSColor.clear

    // MARK: -
    // MARK: Creating Colors

    /// Create a new ThemeColor instance for the specified selector.
    ///
    /// Returns a color returned by calling `selector` on current theme as an instance method or,
    /// if unavailable, the result of calling `themeAsset(_:)` on the current theme.
    ///
    /// - parameter selector: Selector for color method.
    ///
    /// - returns: A `ThemeColor` instance for the specified selector.
    @objc(colorWithSelector:)
    public class func color(with selector: Selector) -> ThemeColor {
        return color(with: selector, colorSpace: nil)
    }

    /// Create a new ThemeColor instance for the specified color name component 
    /// (usually, a string selector).
    ///
    /// Color name component will then be called as a selector on current theme 
    /// as an instance method or, if unavailable, the result of calling 
    /// `themeAsset(_:)` on the current theme.
    ///
    /// - parameter selector: Selector for color method.
    ///
    /// - returns: A `ThemeColor` instance for the specified selector.
    @objc(colorWithColorNameComponent:)
    internal class func color(with colorNameComponent: String) -> ThemeColor {
        return color(with: Selector(colorNameComponent), colorSpace: nil)
    }

    /// Color for a specific theme.
    ///
    /// - parameter theme:    A `Theme` instance.
    /// - parameter selector: A color selector.
    ///
    /// - returns: Resolved color for specified selector on given theme.
    @objc(colorForTheme:selector:)
    public class func color(for theme: Theme, selector: Selector) -> NSColor {
        let cacheKey = CacheKey(selector: selector, theme: theme)
        var color = _cachedThemeColors.object(forKey: cacheKey)

        if color == nil {

            // Theme provides this asset?
            color = theme.themeAsset(NSStringFromSelector(selector)) as? NSColor

            // Otherwise, use fallback colors
            if color == nil {
                color = fallbackColor(for: theme, selector: selector)
            }

            // Store as Calibrated RGB if not a pattern image
            if color?.colorSpaceName != NSColorSpaceName.pattern {
                color = color?.usingColorSpace(.genericRGB)
            }

            // Cache it
            if let themeColor = color {
                _cachedThemeColors.setObject(themeColor, forKey: cacheKey)
            }
        }

        return color ?? fallbackColor(for: theme, selector: selector)
    }

    /// Current theme color, but respecting view appearance and any window
    /// specific theme (if set).
    ///
    /// If a `NSWindow.windowTheme` was set, it will be used instead.
    /// Some views may be using a different appearance than the theme appearance.
    /// In thoses cases, color won't be resolved using current theme, but from 
    /// either `lightTheme` or `darkTheme`, depending of whether view appearance
    /// is light or dark, respectively.
    ///
    /// - parameter view:     A `NSView` instance.
    /// - parameter selector: A color selector.
    ///
    /// - returns: Resolved color for specified selector on given view.
    @objc(colorForView:selector:)
    public class func color(for view: NSView, selector: Selector) -> NSColor {
        // if a custom window theme was set, use the appropriate asset
        if let windowTheme = view.window?.windowTheme {
            return ThemeColor.color(for: windowTheme, selector: selector)
        }

        let theme = ThemeManager.shared.effectiveTheme
        let viewAppearance = view.appearance
        let aquaAppearance = NSAppearance(named: NSAppearance.Name.aqua)
        let lightAppearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
        let darkAppearance = NSAppearance(named: NSAppearance.Name.vibrantDark)

        // using a dark theme but control is on a light surface => use light theme instead
        if theme.isDarkTheme &&
            (viewAppearance == lightAppearance || viewAppearance == aquaAppearance) {
            return ThemeColor.color(for: ThemeManager.lightTheme, selector: selector)
        } else if theme.isLightTheme && viewAppearance == darkAppearance {
            return ThemeColor.color(for: ThemeManager.darkTheme, selector: selector)
        }

        // otherwise, return current theme color
        return ThemeColor.color(with: selector)
    }

    /// Returns a new `ThemeColor` for the given selector in the specified colorspace.
    ///
    /// - parameter selector:   A color selector.
    /// - parameter colorSpace: An optional `NSColorSpace`.
    ///
    /// - returns: A `ThemeColor` instance in the specified colorspace.
    @objc class func color(with selector: Selector, colorSpace: NSColorSpace?) -> ThemeColor {
        let cacheKey = CacheKey(selector: selector, colorSpace: colorSpace)

        if let cachedColor = _cachedColors.object(forKey: cacheKey) {
            return cachedColor
        } else {
            let color = ThemeColor(with: selector, colorSpace: colorSpace)
            _cachedColors.setObject(color, forKey: cacheKey)
            return color
        }
    }

    /// Returns a new `ThemeColor` for the fiven selector in the specified colorpsace.
    ///
    /// - parameter selector:   A color selector.
    /// - parameter colorSpace: An optional `NSColorSpace`.
    ///
    /// - returns: A `ThemeColor` instance in the specified colorspace.
    @objc convenience init(with selector: Selector, colorSpace: NSColorSpace?) {
        self.init()

        // initialize properties
        themeColorSelector = selector
        themeColorSpace = colorSpace

        // cache color
        recacheColor()

        // recache color on theme change
        registerThemeChangeNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeTheme, object: nil)
    }

    /// Register to recache on theme changes.
    @objc func registerThemeChangeNotifications() {
        NotificationCenter.default.removeObserver(self, name: .didChangeTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recacheColor), name: .didChangeTheme, object: nil)
    }

    /// Forces dynamic color resolution into `resolvedThemeColor` and cache it.
    /// You should not need to manually call this function.
    @objc open func recacheColor() {
        // If it is a UserTheme we actually want to discard theme cached values
        if ThemeManager.shared.effectiveTheme.isUserTheme {
            ThemeColor.emptyCache()
        }

        // Recache resolved color
        let newColor = ThemeColor.color(for: ThemeManager.shared.effectiveTheme, selector: themeColorSelector)
        if let colorSpace = themeColorSpace {
            let convertedColor = newColor.usingColorSpace(colorSpace)
            resolvedThemeColor = convertedColor ?? newColor
        } else {
            resolvedThemeColor = newColor
        }

        // Recache average color of pattern image, if appropriate
        themePatternImageAverageColor = resolvedThemeColor.colorSpaceName == NSColorSpaceName.pattern ? resolvedThemeColor.patternImage.averageColor() : NSColor.clear
    }

    /// Clear all caches.
    /// You should not need to manually call this function.
    @objc static open func emptyCache() {
        _cachedColors.removeAllObjects()
        _cachedThemeColors.removeAllObjects()
    }

    /// Fallback color for a specific theme and selector.
    @objc class func fallbackColor(for theme: Theme, selector: Selector) -> NSColor {
        var fallbackColor: NSColor?
        let selectorString = NSStringFromSelector(selector)

        if selectorString.contains("Background") {
            // try with theme provided `fallbackBackgroundColor` method
            if let themeFallbackColor = theme.fallbackBackgroundColor as? NSColor {
                fallbackColor = themeFallbackColor
            }
            // try with theme asset `fallbackBackgroundColor`
            if fallbackColor == nil, let themeAsset = theme.themeAsset("fallbackBackgroundColor") as? NSColor {
                fallbackColor = themeAsset
            }
            // otherwise just use default fallback color
            return fallbackColor ?? theme.defaultFallbackBackgroundColor
        } else {
            // try with theme provided `fallbackForegroundColor` method
            if let themeFallbackColor = theme.fallbackForegroundColor as? NSColor {
                fallbackColor = themeFallbackColor
            }
            // try with theme asset `fallbackForegroundColor`
            if fallbackColor == nil, let themeAsset = theme.themeAsset("fallbackForegroundColor") as? NSColor {
                fallbackColor = themeAsset
            }
            // otherwise just use default fallback color
            return fallbackColor ?? theme.defaultFallbackForegroundColor
        }
    }

    // MARK: - NSColor Overrides

    override open func setFill() {
        resolvedThemeColor.setFill()
    }

    override open func setStroke() {
        resolvedThemeColor.setStroke()
    }

    override open func set() {
        resolvedThemeColor.set()
    }

    override open func usingColorSpace(_ space: NSColorSpace) -> NSColor? {
        return ThemeColor.color(with: themeColorSelector, colorSpace: space)
    }

    override open func usingColorSpaceName(_ colorSpace: NSColorSpaceName?, device deviceDescription: [NSDeviceDescriptionKey: Any]?) -> NSColor? {
        if colorSpace == self.colorSpaceName {
            return self
        }

        let newColorSpace: NSColorSpace
        if colorSpace == NSColorSpaceName.calibratedWhite {
            newColorSpace = .genericGray
        } else if colorSpace == NSColorSpaceName.calibratedRGB {
            newColorSpace = .genericRGB
        } else if colorSpace == NSColorSpaceName.deviceWhite {
            newColorSpace = .deviceGray
        } else if colorSpace == NSColorSpaceName.deviceRGB {
            newColorSpace = .deviceRGB
        } else if colorSpace == NSColorSpaceName.deviceCMYK {
            newColorSpace = .deviceCMYK
        } else if colorSpace == NSColorSpaceName.custom {
            newColorSpace = .genericRGB
        } else {
            /* unsupported colorspace conversion */
            return nil
        }

        return ThemeColor.color(with: themeColorSelector, colorSpace: newColorSpace)
    }

    @objc override open var colorSpaceName: NSColorSpaceName {
        return resolvedThemeColor.colorSpaceName
    }

    override open var colorSpace: NSColorSpace {
        return resolvedThemeColor.colorSpace
    }

    override open var numberOfComponents: Int {
        return resolvedThemeColor.numberOfComponents
    }

    override open func getComponents(_ components: UnsafeMutablePointer<CGFloat>) {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        color.usingColorSpace(.genericRGB)?.getComponents(components)
    }

    override open var redComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let rgbColor = color.usingColorSpace(.genericRGB) {
            return rgbColor.redComponent
        }
        return 0.0
    }

    override open var greenComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let rgbColor = color.usingColorSpace(.genericRGB) {
            return rgbColor.greenComponent
        }
        return 0.0
    }

    override open var blueComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let rgbColor = color.usingColorSpace(.genericRGB) {
            return rgbColor.blueComponent
        }
        return 0.0
    }

    override open func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        color.usingColorSpace(.genericRGB)?.getRed(red, green: green, blue: blue, alpha: alpha)
    }

    override open var cyanComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let cmykColor = color.usingColorSpace(.genericCMYK) {
            return cmykColor.cyanComponent
        }
        return 0.0
    }

    override open var magentaComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let cmykColor = color.usingColorSpace(.genericCMYK) {
            return cmykColor.magentaComponent
        }
        return 0.0
    }

    override open var yellowComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let cmykColor = color.usingColorSpace(.genericCMYK) {
            return cmykColor.yellowComponent
        }
        return 0.0
    }

    override open var blackComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let cmykColor = color.usingColorSpace(.genericCMYK) {
            return cmykColor.blackComponent
        }
        return 0.0
    }

    override open func getCyan(_ cyan: UnsafeMutablePointer<CGFloat>?,
                               magenta: UnsafeMutablePointer<CGFloat>?,
                               yellow: UnsafeMutablePointer<CGFloat>?,
                               black: UnsafeMutablePointer<CGFloat>?,
                               alpha: UnsafeMutablePointer<CGFloat>?) {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        color.usingColorSpace(.genericCMYK)?.getCyan(cyan, magenta: magenta, yellow: yellow, black: black, alpha: alpha)
    }

    override open var whiteComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let grayColor = color.usingColorSpace(.genericGray) {
            return grayColor.whiteComponent
        }
        return 0.0
    }

    override open func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        color.usingColorSpace(.genericGray)?.getWhite(white, alpha: alpha)
    }

    override open var hueComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let rgbColor = color.usingColorSpace(.genericRGB) {
            return rgbColor.hueComponent
        }
        return 0.0
    }

    override open var saturationComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let rgbColor = color.usingColorSpace(.genericRGB) {
            return rgbColor.saturationComponent
        }
        return 0.0
    }

    override open var brightnessComponent: CGFloat {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        if let rgbColor = color.usingColorSpace(.genericRGB) {
            return rgbColor.brightnessComponent
        }
        return 0.0
    }

    override open func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        color.usingColorSpace(.genericRGB)?.getHue(hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    override open func highlight(withLevel val: CGFloat) -> NSColor? {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        return color.highlight(withLevel: val)
    }

    override open func shadow(withLevel val: CGFloat) -> NSColor? {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        return color.shadow(withLevel: val)
    }

    override open func withAlphaComponent(_ alpha: CGFloat) -> NSColor {
        let color = resolvedThemeColor.colorSpaceName != NSColorSpaceName.pattern ? resolvedThemeColor : themePatternImageAverageColor
        return color.withAlphaComponent(alpha)
    }

    override open var description: String {
        return "\(super.description): \(NSStringFromSelector(themeColorSelector))"
    }
}
