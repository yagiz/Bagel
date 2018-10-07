//
//  ThemeManager.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 06/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation
import QuartzCore

/**
 Use `ThemeManager` shared instance to perform app-wide theming related operations,
 such as:
 
 - Get information about current theme/appearance
 - Change current `theme` (can also be changed from `NSUserDefaults`)
 - List available themes
 - Define `ThemeKit` behaviour 
 
 */
@objc(TKThemeManager)
public class ThemeManager: NSObject {

    /// ThemeManager shared manager.
    @objc(sharedManager)
    public static let shared = ThemeManager()
    private var obj: NSObjectProtocol?

    // MARK: -
    // MARK: Initialization & Cleanup

    private override init() {
        super.init()

        // Initialize custom NSColor code (swizzle NSColor, if needed)
        NSColor.swizzleNSColor()

        // Observe and theme new windows (before being displayed onscreen)
        self.obj = NotificationCenter.default.addObserver(forName: NSWindow.didUpdateNotification, object: nil, queue: nil) { (notification) in
            if let window = notification.object as? NSWindow {
                window.themeIfCompliantWithWindowThemePolicy()
            }
        }

        // Observe current theme on User Defaults
        NSUserDefaultsController.shared.addObserver(self, forKeyPath: themeChangeKVOKeyPath, options: NSKeyValueObservingOptions(rawValue: 0), context: nil)

        // Observe current system theme (macOS Apple Interface Theme)
        NotificationCenter.default.addObserver(self, selector: #selector(systemThemeDidChange(_:)), name: .didChangeSystemTheme, object: nil)
    }

    deinit {
        if let object = self.obj {
          NotificationCenter.default.removeObserver(object)
        }
        NSUserDefaultsController.shared.removeObserver(self, forKeyPath: themeChangeKVOKeyPath)
    }

    // MARK: -
    // MARK: Themes

    /// Sets or returns the current theme.
    ///
    /// This property is KVO compliant. Value is stored on user defaults under key
    /// `userDefaultsThemeKey`.
    @objc public var theme: Theme {
        get {
            return _theme ?? ThemeManager.defaultTheme
        }
        set(newTheme) {
            // Apply theme
            if _theme == nil || newTheme.effectiveTheme != _theme! || newTheme.effectiveTheme.isUserTheme {
                applyTheme(newTheme)
            }

            // Store identifier on user defaults
            if newTheme.identifier != UserDefaults.standard.string(forKey: ThemeManager.userDefaultsThemeKey) {
                _storingThemeOnUserDefaults = true
                UserDefaults.standard.set(newTheme.identifier, forKey: ThemeManager.userDefaultsThemeKey)
                _storingThemeOnUserDefaults = false
            }
        }
    }
    /// Internal storage for `theme` property. Doesn't trigger an `applyTheme()` call.
    private var _theme: Theme?
    /// Internal variable set when storing theme on user defaults, to prevent infinte loops.
    private var _storingThemeOnUserDefaults: Bool = false

    /// Returns the current effective theme (read-only).
    ///
    /// This property is KVO compliant. This can return a different result than
    /// `theme`, as if current theme is set to `SystemTheme`, effective theme
    /// will be either `lightTheme` or `darkTheme`, respecting user preference at
    /// **System Preferences > General > Appearance**.
    @objc public var effectiveTheme: Theme {
        return theme.effectiveTheme
    }

    /// List all available themes:
    ///
    /// - Built-in `lightTheme`
    /// - Built-in `darkTheme`
    /// - Built-in `systemTheme`
    /// - All native themes (extending `NSObject` and conforming to `Theme` protocol)
    /// - All user themes (loaded from `.theme` files)
    ///
    /// This property is KVO compliant and will change when changes occur on user
    /// themes folder.
    @objc public var themes: [Theme] {
        if cachedThemes == nil {
            var available = [Theme]()

            // Append theme to the list, reloading if user theme
            func appendTheme(_ theme: Theme) {
                if theme.isUserTheme, let userTheme = theme as? UserTheme {
                    userTheme.reload()
                }
                available.append(theme)
            }

            // Builtin themes
            appendTheme(ThemeManager.lightTheme)
            appendTheme(ThemeManager.darkTheme)
            appendTheme(ThemeManager.systemTheme)

            // Developer native themes (conforming to NSObject, Theme)
            for cls in NSObject.classesImplementingProtocol(Theme.self) {
                if cls !== LightTheme.self && cls !== DarkTheme.self && cls !== SystemTheme.self && cls !== UserTheme.self,
                    let themeClass = cls as? NSObject.Type,
                    let theme = themeClass.init() as? Theme {
                    available.append(theme)
                }
            }

            // User provided themes
            available.append(contentsOf: userThemes)

            cachedThemes = available
        }
        return cachedThemes ?? []
    }

    /// List all user themes (`UserTheme` class, loaded from `.theme` files)
    @objc public var userThemes: [Theme] {
        if cachedUserThemes == nil {
            var available = [Theme]()

            // User provided themes
            for filename in userThemesFileNames {
                if let themeFileURL = userThemesFolderURL?.appendingPathComponent(filename) {
                    available.append(UserTheme(themeFileURL))
                }
            }

            cachedUserThemes = available
        }
        return cachedUserThemes ?? []
    }

    /// Cached themes list (private use).
    private var cachedThemes: [Theme]?

    /// Cached user themes list (private use).
    private var cachedUserThemes: [Theme]?

    /// Convenience method for accessing the light theme.
    ///
    /// This property can be changed so that `SystemTheme` resolves to this theme
    /// instead of the default `LightTheme`.
    @objc public static var lightTheme: Theme = LightTheme()

    /// Convenience method for accessing the dark theme.
    ///
    /// This property can be changed so that `SystemTheme` resolves to this theme
    /// instead of the default `DarkTheme`.
    @objc public static var darkTheme: Theme = DarkTheme()

    /// Convenience method for accessing the theme that dynamically changes to
    /// `ThemeManager.lightTheme` or `ThemeManager.darkTheme`, respecting user preference
    /// at **System Preferences > General > Appearance**.
    @objc public static let systemTheme = SystemTheme()

    /// Set/get default theme to be used on the first run (default: `ThemeManager.systemTheme`).
    @objc public static var defaultTheme: Theme = ThemeManager.systemTheme

    /// Get the theme with specified identifier.
    ///
    /// - parameter identifier: The unique `Theme.identifier` string.
    ///
    /// - returns: The `Theme` instance with the given identifier.
    @objc public func theme(withIdentifier identifier: String?) -> Theme? {
        if let themeIdentifier: String = identifier {
            for theme in themes where theme.identifier == themeIdentifier {
                return theme
            }
        }
        return nil
    }

    /// User defaults key for current `theme`.
    ///
    /// Current `theme.identifier` will be stored under the `"ThemeKitTheme"` `NSUserDefaults` key.
    @objc static public let userDefaultsThemeKey = "ThemeKitTheme"

    /// Apply last applied theme, or default, if none.
    ///
    /// Get last applied theme from user defaults and load it. If no theme was
    /// previously applied, load the default theme (`ThemeManager.defaultTheme`).
    @objc public func applyLastOrDefaultTheme() {
        let userDefaultsTheme = theme(withIdentifier: UserDefaults.standard.string(forKey: ThemeManager.userDefaultsThemeKey))
        (userDefaultsTheme ?? ThemeManager.defaultTheme).apply()
    }

    /// Force-apply current `theme`.
    ///
    /// Normally you should not need to invoke this method, as this will
    /// force-apply the same theme.
    @objc public func reApplyCurrentTheme() {
        applyTheme(theme)
    }

    /// Apple Interface theme has changed.
    ///
    /// - parameter notification: A `.didChangeSystemTheme` notification.
    @objc private func systemThemeDidChange(_ notification: Notification) {
        if theme.isSystemTheme {
            applyTheme(theme)
        }
    }

    // MARK: -
    // MARK: User Themes (`.theme` files)

    /// Location of user provided themes (.theme files).
    ///
    /// Ideally, this should be on a shared location, like `Application Support/{app_bundle_id}/Themes`
    /// for example. Here's an example of how to get this folder (*):
    ///
    /// ```swift
    /// public var applicationSupportUserThemesFolderURL: URL {
    ///   let applicationSupportURLs = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
    ///   let thisAppSupportURL = URL(fileURLWithPath: applicationSupportURLs.first!).appendingPathComponent(Bundle.main.bundleIdentifier!)
    ///   return thisAppSupportURL.appendingPathComponent("Themes")
    /// }
    /// ```
    ///
    /// *: force wrapping (!) is for illustrative purposes only.
    ///
    /// You can also bundle these files with your application bundle, if you 
    /// don't want them to be changed.
    @objc public var userThemesFolderURL: URL? {
        didSet {
            // Clean up previous
            _userThemesFolderSource?.cancel()

            // Observe User Themes folder via CGD dispatch sources
            if let url = userThemesFolderURL, url != oldValue {
                // Create folder if needed
                do {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print("Unable to create `Themes` directory: \(error.debugDescription)")
                    userThemesFolderURL = nil
                    return
                }

                // Initialize file descriptor
                let fileDescriptor = open((url.path as NSString).fileSystemRepresentation, O_EVTONLY)
                guard fileDescriptor >= 0 else { return }

                // Initialize dispatch queue
                _userThemesFolderQueue = DispatchQueue(label: "com.luckymarmot.ThemeKit.UserThemesFolderQueue")

                // Watch file descriptor for writes
                _userThemesFolderSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: DispatchSource.FileSystemEvent.write)
                _userThemesFolderSource?.setEventHandler(handler: {
                    self.userThemesFolderChangedContent()
                })

                // Clean up when dispatch source is cancelled
                _userThemesFolderSource?.setCancelHandler {
                    close(fileDescriptor)
                }

                // Start watching
                willChangeValue(forKey: #keyPath(themes))
                willChangeValue(forKey: #keyPath(userThemes))
                cachedThemes = nil
                cachedUserThemes = nil
                _userThemesFolderSource?.resume()
                didChangeValue(forKey: #keyPath(userThemes))
                didChangeValue(forKey: #keyPath(themes))

                // Re-apply current theme if user theme
                if theme.effectiveTheme.isUserTheme {
                    reApplyCurrentTheme()
                }
            }
        }
    }

    /// List of user themes file names.
    private var userThemesFileNames: [String] {
        guard let url = userThemesFolderURL, FileManager.default.fileExists(atPath: url.path, isDirectory: nil) else {
            return []
        }
        if let folderFiles = try? FileManager.default.contentsOfDirectory(atPath: url.path) as NSArray {
            let themeFileNames = folderFiles.filtered(using: NSPredicate(format: "self ENDSWITH '.theme'", argumentArray: nil))
            return themeFileNames.map({ (fileName: Any) -> String in
                return fileName as? String ?? ""
            })
        }
        return []
    }

    /// Dispatch queue for monitoring the user themes folder.
    private var _userThemesFolderQueue: DispatchQueue?

    /// Filesustem dispatch source for monitoring the user themes folder.
    private var _userThemesFolderSource: DispatchSourceFileSystemObject?

    /// Called when themes folder has file changes --> refresh modified user theme (if current).
    private func userThemesFolderChangedContent() {
        willChangeValue(forKey: #keyPath(themes))
        willChangeValue(forKey: #keyPath(userThemes))
        cachedThemes = nil
        cachedUserThemes = nil

        if effectiveTheme.isUserTheme {
            applyLastOrDefaultTheme()
        }

        didChangeValue(forKey: #keyPath(userThemes))
        didChangeValue(forKey: #keyPath(themes))
    }

    // MARK: -
    // MARK: Appearances

    /// Appearance in use for effective theme.
    @objc public var effectiveThemeAppearance: NSAppearance {
        return (effectiveTheme.isLightTheme ? lightAppearance : darkAppearance) ?? NSAppearance.current
    }

    /// Convenience method to get the light appearance.
    @objc public var lightAppearance: NSAppearance? {
        return NSAppearance(named: NSAppearance.Name.vibrantLight)
    }

    /// Convenience method to get the dark appearance.
    @objc public var darkAppearance: NSAppearance? {
        return NSAppearance(named: NSAppearance.Name.vibrantDark)
    }

    // MARK: -
    // MARK: Window Theming Policy

    /// Window theme policies that define which windows should be automatically themed, if any.
    ///
    /// Swift
    /// -----
    /// By default, all application windows (except `NSPanel`) will be themed (`.themeAllWindows`).
    ///
    /// - `themeAllWindows`:   Theme all application windows, except `NSPanel` subclasses (default).
    /// - `themeSomeWindows`:  Only theme windows of the specified classes.
    /// - `doNotThemeSomeWindows`: Do not theme windows of the specified classes.
    /// - `doNotThemeWindows`: Do not theme any window.E.g.:
    ///
    /// E.g.:
    ///
    /// ```
    /// ThemeManager.shared.windowThemePolicy = .themeSomeWindows(windowClasses: [CustomWindow.self])
    /// ```
    ///
    /// Objective-C
    /// -----------
    /// By default, all application windows (except `NSPanel`) will be themed (`TKThemeManagerWindowThemePolicyThemeAllWindows`).
    ///
    /// - `TKThemeManagerWindowThemePolicyThemeAllWindows`:   Theme all application windows, except `NSPanel` subclasses (default).
    /// - `TKThemeManagerWindowThemePolicyThemeSomeWindows`:  Only theme windows of the specified classes (use `themableWindowClasses` property).
    /// - `TKThemeManagerWindowThemePolicyDoNotThemeSomeWindows`:  Do not theme windows of the specified classes (use `notThemableWindowClasses` property).
    /// - `TKThemeManagerWindowThemePolicyDoNotThemeWindows`: Do not theme any window.
    ///
    /// Example:
    /// ```
    /// [TKThemeManager sharedManager].windowThemePolicy = TKThemeManagerWindowThemePolicyThemeSomeWindows;
    /// [TKThemeManager sharedManager].themableWindowClasses = @[[CustomWindow class]];
    /// ```
    ///
    /// NSWindow Extension
    /// ------------------
    ///
    /// - `NSWindow.theme()`
    ///
    ///     Theme window if appearance needs update. Doesn't check for policy compliance.
    /// - `NSWindow.isCompliantWithWindowThemePolicy()`
    ///
    ///     Check if window complies to current policy.
    /// - `NSWindow.themeIfCompliantWithWindowThemePolicy()`
    ///
    ///     Theme window if compliant to `windowThemePolicy` (and if appearance needs update).
    /// - `NSWindow.themeAllWindows()`
    ///
    ///     Theme all windows compliant to ThemeManager.windowThemePolicy (and if appearance needs update).
    public enum WindowThemePolicy {
        /// Theme all application windows (default).
        case themeAllWindows
        /// Only theme windows of the specified classes.
        case themeSomeWindows(windowClasses: [AnyClass])
        /// Do not theme windows of the specified classes.
        case doNotThemeSomeWindows(windowClasses: [AnyClass])
        /// Do not theme any window.
        case doNotThemeWindows
    }

    /// Current window theme policy.
    public var windowThemePolicy: WindowThemePolicy = .themeAllWindows

    // MARK: -
    // MARK: Theme Switching

    /// Animate theme transitions?
    @objc public var animateThemeTransitions: Bool = true

    /// Keypath for string `values.ThemeKitTheme`.
    private var themeChangeKVOKeyPath: String = "values.\(ThemeManager.userDefaultsThemeKey)"

    // Called when theme is changed on `NSUserDefaults`.
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == themeChangeKVOKeyPath && !_storingThemeOnUserDefaults else { return }

        // Theme selected on user defaults
        let userDefaultsThemeIdentifier = UserDefaults.standard.string(forKey: ThemeManager.userDefaultsThemeKey)

        // Theme was changed on user defaults -> apply
        if userDefaultsThemeIdentifier != theme.identifier {
            applyLastOrDefaultTheme()
        }
    }

    /// Screenshot-windows used during theme animated transition.
    private var themeTransitionWindows: Set<NSWindow> = Set()

    /// Apply a new `theme`.
    private func applyTheme(_ newTheme: Theme) {

        // Make theme effective
        func makeThemeEffective(_ newTheme: Theme) {
            // Determine new theme
            let oldEffectiveTheme: Theme = effectiveTheme
            let newEffectiveTheme: Theme = newTheme.effectiveTheme

            // Apply & Propagate changes
            func applyAndPropagate(_ newTheme: Theme) {
                Thread.onMain {
                    // Will change...
                    self.willChangeValue(forKey: #keyPath(theme))
                    let changingEffectiveAppearance = self._theme == nil || self.effectiveTheme != newTheme.effectiveTheme
                    if changingEffectiveAppearance {
                        self.willChangeValue(forKey: #keyPath(effectiveTheme))
                    }
                    NotificationCenter.default.post(name: .willChangeTheme, object: newTheme)

                    // Change effective theme
                    self._theme = newTheme

                    // Did change!
                    self.didChangeValue(forKey: #keyPath(theme))
                    if changingEffectiveAppearance {
                        self.didChangeValue(forKey: #keyPath(effectiveTheme))
                    }
                    NotificationCenter.default.post(name: .didChangeTheme, object: newTheme)

                    // Theme all windows compliant to current `windowThemePolicy`
                    NSWindow.themeAllWindows()
                }
            }

            // If we are switching light-to-light or dark-to-dark themes, macOS won't
            // refresh appearance on controls => need to 'tilt' appearance to force refresh!
            // Additionally, we are "force refreshing" on initial theming and
            // when swithing `UserTheme` themes.
            if oldEffectiveTheme.isLightTheme == newEffectiveTheme.isLightTheme || _theme == nil || newTheme.isUserTheme {
                // Switch to "inverted" theme (light -> dark, dark -> light)
                applyAndPropagate(oldEffectiveTheme.isLightTheme ? ThemeManager.darkTheme : ThemeManager.lightTheme)
            }

            // Switch to new theme
            applyAndPropagate(newTheme)
        }

        Thread.onMain { [unowned self] in
            // Animate theme transition
            if self.animateThemeTransitions {
                // Find windows to animate
                let windows = NSWindow.windowsCompliantWithWindowThemePolicy()
                guard windows.count > 0 else {
                    // Change theme without animation
                    makeThemeEffective(newTheme)
                    return
                }

                // Create transition windows off-screen
                var transitionWindows = [Int: NSWindow]()
                for window in windows {
                    let windowNumber = window.windowNumber
                    /* Make sure the window has a number, and that it's not one of our
                     * existing transition windows */
                    if windowNumber > 0 && !self.themeTransitionWindows.contains(window) {
                        let transitionWindow = window.makeScreenshotWindow()
                        transitionWindows[windowNumber] = transitionWindow
                        self.themeTransitionWindows.insert(transitionWindow)
                    }
                }

                // Show (if we have at least one window to animate)
                if transitionWindows.count > 0 {
                    // Show them all (hidden)
                    for (windowNumber, transitionWindow) in transitionWindows {
                        transitionWindow.alphaValue = 0.0
                        let parentWindow = NSApp.window(withWindowNumber: windowNumber)
                        parentWindow?.addChildWindow(transitionWindow, ordered: .above)
                    }

                    // Setup animation
                    NSAnimationContext.beginGrouping()
                    let ctx = NSAnimationContext.current
                    ctx.duration = 0.3
                    ctx.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    ctx.completionHandler = {() -> Void in
                        for transitionWindow in transitionWindows.values {
                            transitionWindow.orderOut(self)
                            self.themeTransitionWindows.remove(transitionWindow)
                        }
                    }

                    // Show them all and fade out
                    for transitionWindow in transitionWindows.values {
                        transitionWindow.alphaValue = 1.0
                        transitionWindow.animator().alphaValue = 0.0
                    }
                    NSAnimationContext.endGrouping()

                }
            }

            // Actually change theme
            makeThemeEffective(newTheme)
        }
    }

    // MARK: -
    // MARK: Notifications

    /// ThemeKit notification sent when current theme is about to change.
    @objc public static let willChangeThemeNotification = Notification.Name.willChangeTheme

    /// ThemeKit notification sent when current theme did change.
    @objc public static let didChangeThemeNotification = Notification.Name.didChangeTheme

    /// ThemeKit notification sent when system theme did change (System Preference > General > Appearance).
    @objc public static let didChangeSystemThemeNotification = Notification.Name.didChangeSystemTheme

}
