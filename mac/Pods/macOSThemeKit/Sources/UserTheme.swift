//
//  UserTheme.swift
//  ThemeKit
//
//  Created by Nuno Grilo on 06/09/16.
//  Copyright © 2016 Paw & Nuno Grilo. All rights reserved.
//

import Foundation

/**
 A `Theme` class wrapping a user provided theme file (`.theme`).
 
 To enable user themes, set theme folder on `ThemeManager.userThemesFolderURL`.

 Notes about `.theme` files:
 
 - lines starting with `#` or `//` will be treated as comments, thus, ignored;
 - non-comment lines consists on simple variable/value assignments (eg, `variable = value`);
 - `variable` name can contain characters `[a-zA-Z0-9_-.]+`;
 - custom variables can be specified (eg, `myBackgroundColor = ...`);
 - theming properties match the class methods of `ThemeColor`, `ThemeGradient` and `ThemeImage` (eg, `labelColor`);
 - variables can be referenced by prefixing them with `$` (eg, `mainBorderColor = $commonBorderColor`);
 - colors are defined using `rgb(255, 255, 255)` or `rgba(255, 255, 255, 1.0)` (case insensitive);
 - gradients are defined using `linear-gradient(color1, color2)` (where colors are defined as above; case insensitive);
 - pattern images are defined using `pattern(named:xxxx)` (named images) or `pattern(file:../dddd/xxxx.yyy)` (filesystem images);
 - images are defined using `image(named:xxxx)` (named images) or `image(file:../dddd/xxxx.yyy)` (filesystem images);
 - `ThemeManager.themes` property is automatically updated when there are changes on the user themes folder;
 - file changes are applied on-the-fly, if it corresponds to the currently applied theme.
 
 Example `.theme` file:
 
 ```ruby
 // ************************* Theme Info ************************* //
 displayName = My Theme 1
 identifier = com.luckymarmot.ThemeKit.MyTheme1
 darkTheme = true
 
 // ********************* Colors & Gradients ********************* //
 # define color for `ThemeColor.brandColor`
 brandColor = $blue
 # define a new color for `NSColor.labelColor` (overriding)
 labelColor = rgb(11, 220, 111)
 # define gradient for `ThemeGradient.brandGradient`
 brandGradient = linear-gradient($orange.sky, rgba(200, 140, 60, 1.0))
 
 // ********************* Images & Patterns ********************** //
 # define pattern image from named image "paper" for color `ThemeColor.contentBackgroundColor`
 contentBackgroundColor = pattern(named:paper)
 # define pattern image from filesystem (relative to user themes folder) for color `ThemeColor.bottomBackgroundColor`
 bottomBackgroundColor = pattern(file:../some/path/some-file.png)
 # use named image "apple"
 namedImage = image(named:apple)
 # use image from filesystem (relative to user themes folder)
 fileImage = image(file:../some/path/some-file.jpg)
 
 // *********************** Common Colors ************************ //
 blue = rgb(0, 170, 255)
 orange.sky = rgb(160, 90, 45, .5)
 
 // ********************** Fallback Assets *********************** //
 fallbackForegroundColor = rgb(255, 10, 90, 1.0)
 fallbackBackgroundColor = rgb(255, 200, 190)
 fallbackGradient = linear-gradient($blue, rgba(200, 140, 60, 1.0))
 ```
 
 With the exception of system overrided named colors (e.g., `labelColor`), which
 defaults to the original system provided named color, unimplemented properties 
 on theme file will default to `-fallbackForegroundColor`, `-fallbackBackgroundColor`,
 `-fallbackGradient` and `-fallbackImage`, for foreground color, background color,
 gradients and images, respectively.
 
 
 */
@objc(TKUserTheme)
public class UserTheme: NSObject, Theme {
    /// Unique theme identifier.
    public var identifier: String = "{Theme-Not-Loaded}"

    /// Theme display name.
    public var displayName: String = "Theme Not Loaded"

    /// Theme short display name.
    public var shortDisplayName: String = "Not Loaded"

    /// Is this a dark theme?
    public var isDarkTheme: Bool = false

    /// File URL.
    @objc public var fileURL: URL?

    /// Dictionary with key/values pairs read from the .theme file
    private var _keyValues: NSMutableDictionary = NSMutableDictionary()

    /// Dictionary with evaluated key/values pairs read from the .theme file
    private var _evaluatedKeyValues: NSMutableDictionary = NSMutableDictionary()

    // MARK: -
    // MARK: Initialization

    /// `init()` is disabled.
    private override init() {
        super.init()
    }

    /// Calling `init(_:)` is not allowed outside this library.
    /// Use `ThemeManager.shared.theme(:_)` instead.
    ///
    /// - parameter themeFileURL: A theme file (`.theme`) URL.
    ///
    /// - returns: An instance of `UserTheme`.
    @objc internal init(_ themeFileURL: URL) {
        super.init()

        // Load file
        fileURL = themeFileURL
        loadThemeFile(from: themeFileURL)
    }

    /// Reloads user theme from file.
    @objc public func reload() {
        if let url = fileURL {
            _keyValues.removeAllObjects()
            _evaluatedKeyValues.removeAllObjects()
            loadThemeFile(from: url)
        }
    }

    // MARK: -
    // MARK: Theme Assets

    /// Theme asset for the specified key. Supported assets are `NSColor`, `NSGradient`, `NSImage` and `NSString`.
    ///
    /// - parameter key: A color name, gradient name, image name or a theme string
    ///
    /// - returns: The theme value for the specified key.
    @objc public func themeAsset(_ key: String) -> Any? {
        var value = _evaluatedKeyValues[key]
        if value == nil,
            let evaluatedValue = _keyValues.evaluatedObject(key: key) {
            value = evaluatedValue
            _evaluatedKeyValues.setObject(evaluatedValue, forKey: key as NSString)
        }
        return value
    }

    /// Checks if a theme asset is provided for the given key.
    ///
    /// Do not check for theme asset availability with `themeAsset(_:)`, use
    /// this method instead, which is much faster.
    ///
    /// - parameter key: A color name, gradient name, image name or a theme string
    ///
    /// - returns: `true` if theme provides an asset for the given key; `false` otherwise.
    @objc public func hasThemeAsset(_ key: String) -> Bool {
        return _keyValues[key] != nil
    }

    // MARK: -
    // MARK: File

    /// Load theme file
    ///
    /// - parameter from: A theme file (`.theme`) URL.
    private func loadThemeFile(from: URL) {
        // Load contents from theme file
        if let themeContents = try? String(contentsOf: from, encoding: String.Encoding.utf8) {

            // Split content into lines
            var lineCharset = CharacterSet(charactersIn: ";")
            lineCharset.formUnion(CharacterSet.newlines)
            let lines: [String] = themeContents.components(separatedBy: lineCharset)

            // Parse lines
            for line in lines {
                // Trim
                let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespaces)

                // Skip comments
                if trimmedLine.hasPrefix("#") || trimmedLine.hasPrefix("//") {
                    continue
                }

                // Assign theme key-values (lazy evaluation)
                let assignment = trimmedLine.components(separatedBy: "=")
                if assignment.count == 2 {
                    let key = assignment[0].trimmingCharacters(in: CharacterSet.whitespaces)
                    let value = assignment[1].trimmingCharacters(in: CharacterSet.whitespaces)
                    _keyValues.setObject(value, forKey: key as NSString)
                }
            }

            // Initialize properties with evaluated values from file

            // Identifier
            if let identifierString = themeAsset("identifier") as? String {
                identifier = identifierString
            } else {
                identifier = "{identifier: is mising}"
            }

            // Display Name
            if let displayNameString = themeAsset("displayName") as? String {
                displayName = displayNameString
            } else {
                displayName = "{displayName: is mising}"
            }

            // Short Display Name
            if let shortDisplayNameString = themeAsset("shortDisplayName") as? String {
                shortDisplayName = shortDisplayNameString
            } else {
                shortDisplayName = "{shortDisplayName: is mising}"
            }

            // Dark?
            if let isDarkThemeString = themeAsset("darkTheme") as? String {
                isDarkTheme = NSString(string: isDarkThemeString).boolValue
            } else {
                isDarkTheme = false
            }
        }
    }

    override public var description: String {
        return "<\(UserTheme.self): \(themeDescription(self))>"
    }
}
