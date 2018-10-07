//
//  NSWindow+ThemeKit.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 08/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

/**
 `NSWindow` ThemeKit extension.
 */
public extension NSWindow {

    // MARK: -
    // MARK: Properties

    /// Any window specific theme.
    ///
    /// This is, usually, `nil`, which means the current global theme will be used.
    /// Please note that when using window specific themes, only the associated
    /// `NSAppearance` will be automatically set. All theme aware assets (`ThemeColor`,
    /// `ThemeGradient` and `ThemeImage`) should call methods that returns a
    /// resolved color instead (which means they don't change with the theme change,
    /// you need to observe theme changes manually, and set colors afterwards):
    ///
    /// - `ThemeColor.color(for view:, selector:)`
    /// - `ThemeGradient.gradient(for view:, selector:)`
    /// - `ThemeImage.image(for view:, selector:)`
    ///
    /// Additionaly, please note that system overriden colors (`NSColor.*`) will
    /// always use the global theme.
    @objc public var windowTheme: Theme? {
        get {
            return objc_getAssociatedObject(self, &themeAssociationKey) as? Theme
        }
        set(newValue) {
            objc_setAssociatedObject(self, &themeAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            theme()
        }
    }

    /// Returns the current effective theme (read-only).
    @objc public var windowEffectiveTheme: Theme {
        return windowTheme ?? ThemeManager.shared.effectiveTheme
    }

    /// Returns the current effective appearance (read-only).
    @objc public var windowEffectiveThemeAppearance: NSAppearance? {
        return windowEffectiveTheme.isLightTheme ? ThemeManager.shared.lightAppearance : ThemeManager.shared.darkAppearance
    }

    // MARK: -
    // MARK: Theming

    /// Theme window if needed.
    @objc public func theme() {
        if currentTheme == nil || currentTheme! != windowEffectiveTheme {
            // Keep record of currently applied theme
            currentTheme = windowEffectiveTheme

            // Change window tab bar appearance
            themeTabBar()

            // Change window appearance
            themeWindow()
        }
    }

    /// Theme window if compliant to ThemeManager.windowThemePolicy (and if needed).
    @objc public func themeIfCompliantWithWindowThemePolicy() {
        if isCompliantWithWindowThemePolicy() {
            theme()
        }
    }

    /// Theme all windows compliant to ThemeManager.windowThemePolicy (and if needed).
    @objc public static func themeAllWindows() {
        for window in windowsCompliantWithWindowThemePolicy() {
            window.theme()
        }
    }

    // MARK: - Private
    // MARK: - Window theme policy compliance

    /// Check if window is compliant with ThemeManager.windowThemePolicy.
    @objc internal func isCompliantWithWindowThemePolicy() -> Bool {
        switch ThemeManager.shared.windowThemePolicy {

        case .themeAllWindows:
            return !self.isExcludedFromTheming

        case .themeSomeWindows(let windowClasses):
            for windowClass in windowClasses where self.classForCoder === windowClass.self {
                return true
            }
            return false

        case .doNotThemeSomeWindows(let windowClasses):
            for windowClass in windowClasses where self.classForCoder === windowClass.self {
                return false
            }
            return true

        case .doNotThemeWindows:
            return false
        }
    }

    /// List of all existing windows compliant to ThemeManager.windowThemePolicy.
    @objc internal static func windowsCompliantWithWindowThemePolicy() -> [NSWindow] {
        var windows = [NSWindow]()

        switch ThemeManager.shared.windowThemePolicy {

        case .themeAllWindows:
            windows = NSApplication.shared.windows

        case .themeSomeWindows:
            windows = NSApplication.shared.windows.filter({ (window) -> Bool in
                return window.isCompliantWithWindowThemePolicy()
            })

        case .doNotThemeSomeWindows:
            windows = NSApplication.shared.windows.filter({ (window) -> Bool in
                return window.isCompliantWithWindowThemePolicy()
            })

        case .doNotThemeWindows:
            break
        }

        return windows
    }

    /// Returns if current window is excluded from theming
    @objc internal var isExcludedFromTheming: Bool {
        return self is NSPanel
    }

    // MARK: - Window screenshots

    /// Take window screenshot.
    @objc internal func takeScreenshot() -> NSImage? {
        guard let cgImage = CGWindowListCreateImage(CGRect.null, .optionIncludingWindow, CGWindowID(windowNumber), .boundsIgnoreFraming) else {
            return nil
        }

        let image = NSImage(cgImage: cgImage, size: frame.size)
        image.cacheMode = NSImage.CacheMode.never
        image.size = frame.size
        return image
    }

    /// Create a window with a screenshot of current window.
    @objc internal func makeScreenshotWindow() -> NSWindow {
        // Create "image-window"
        let window = NSWindow(contentRect: frame, styleMask: NSWindow.StyleMask.borderless, backing: NSWindow.BackingStoreType.buffered, defer: true)
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.ignoresMouseEvents = true
        window.collectionBehavior = NSWindow.CollectionBehavior.stationary
        window.titlebarAppearsTransparent = true

        // Take window screenshot
        if let screenshot = takeScreenshot(),
            let parentView = window.contentView {
            // Add image view
            let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: screenshot.size.width, height: screenshot.size.height))
            imageView.image = screenshot
            parentView.addSubview(imageView)
        }

        return window
    }

    // MARK: - Caching

    /// Currently applied window theme.
    private var currentTheme: Theme? {
        get {
            return objc_getAssociatedObject(self, &currentThemeAssociationKey) as? Theme
        }
        set(newValue) {
            objc_setAssociatedObject(self, &currentThemeAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            purgeTheme()
        }
    }

    private func purgeTheme() {
        tabBar = nil
    }

    // MARK: - Tab bar view

    /// Returns the tab bar view.
    private var tabBar: NSView? {
        get {
            // If cached, return it
            if let storedTabBar = objc_getAssociatedObject(self, &tabbarAssociationKey) as? NSView {
                return storedTabBar
            }

            var _tabBar: NSView?

            // Search on titlebar accessory views if supported (will fail if tab bar is hidden)
            let themeFrame = self.contentView?.superview
            if themeFrame?.responds(to: #selector(getter: titlebarAccessoryViewControllers)) ?? false {
                for controller: NSTitlebarAccessoryViewController in self.titlebarAccessoryViewControllers {
                    if let possibleTabBar = controller.view.deepSubview(withClassName: "NSTabBar") {
                        _tabBar = possibleTabBar
                        break
                    }
                }
            }

            // Search down the title bar view
            if _tabBar == nil {
                let titlebarContainerView = themeFrame?.deepSubview(withClassName: "NSTitlebarContainerView")
                let titlebarView = titlebarContainerView?.deepSubview(withClassName: "NSTitlebarView")
                _tabBar = titlebarView?.deepSubview(withClassName: "NSTabBar")
            }

            // Remember it
            if _tabBar != nil {
                objc_setAssociatedObject(self, &tabbarAssociationKey, _tabBar, .OBJC_ASSOCIATION_RETAIN)
            }

            return _tabBar
        }

        set(newValue) {
            objc_setAssociatedObject(self, &tabbarAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// Check if tab bar is visbile.
    private var isTabBarVisible: Bool {
        return tabBar?.superview != nil
    }

    /// Update window appearance (if needed).
    private func themeWindow() {
        if appearance != windowEffectiveThemeAppearance {
            // Change window appearance
            appearance = windowEffectiveThemeAppearance

            // Invalidate shadow as sometimes it is incorrecty drawn or missing
            invalidateShadow()

            if #available(macOS 10.12, *) {
                // We're all good here: windows are properly refreshed!
            } else {
                // Need a trick to force update of all CALayers down the view hierarchy
                self.titlebarAppearsTransparent = !self.titlebarAppearsTransparent
                DispatchQueue.main.async {
                    self.titlebarAppearsTransparent = !self.titlebarAppearsTransparent
                }
            }
        }
    }

    /// Update tab bar appearance (if needed).
    private func themeTabBar() {
        guard let _tabBar = tabBar,
            isTabBarVisible && _tabBar.appearance != windowEffectiveThemeAppearance else {
            return
        }

        // Change tabbar appearance
        _tabBar.appearance = windowEffectiveThemeAppearance

        // Refresh its subviews
        for tabBarSubview: NSView in _tabBar.subviews {
            tabBarSubview.needsDisplay = true
        }

        // Also, make sure tabbar is on top (this also properly refreshes it)
        if let tabbarSuperview = _tabBar.superview {
            tabbarSuperview.addSubview(_tabBar)
        }
    }

    // MARK: - Title bar view

    /// Returns the title bar view.
    private var titlebarView: NSView? {
        let themeFrame = self.contentView?.superview
        let titlebarContainerView = themeFrame?.deepSubview(withClassName: "NSTitlebarContainerView")
        return titlebarContainerView?.deepSubview(withClassName: "NSTitlebarView")
    }
}

private var currentThemeAssociationKey: UInt8 = 0
private var themeAssociationKey: UInt8 = 1
private var tabbarAssociationKey: UInt8 = 2
