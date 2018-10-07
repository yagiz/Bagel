<p align="left" style="margin-top: 20px;">
  <img src="https://github.com/luckymarmot/ThemeKit/raw/master/Imgs/ThemeKit@2x.png" width="377" height="105" alt="ThemeKit" />
</p>

![macOS](https://img.shields.io/badge/os-macOS%2010.10%2B-green.svg?style=flat)
![Swift3](https://img.shields.io/badge/swift-4-green.svg?style=flat)
![Release](https://img.shields.io/badge/release-1.2.2-blue.svg?style=flat)
![MIT](https://img.shields.io/badge/license-MIT-lightgray.svg)
![CocoaPods](https://img.shields.io/badge/dep-CocoaPods-orange.svg)
![Carthage](https://img.shields.io/badge/dep-Carthage-orange.svg)

## Summary

*ThemeKit* is a lightweight theming library completely written in Swift that provides theming capabilities to both Swift and Objective-C macOS applications.

*ThemeKit* is brought to you with ❤️ by [Nuno Grilo](http://nunogrilo.com) and the [Paw](https://paw.cloud) [team](https://github.com/orgs/luckymarmot/people).

<p align="left">
  <img src="https://github.com/luckymarmot/ThemeKit/raw/master/Imgs/ThemeKit.gif" width="675" height="378" alt="ThemeKit Animated Demo" />
</p>


### QuickStart

* Download the [ThemeKit Demo](https://github.com/luckymarmot/ThemeKit/raw/master/Demo/Bin/Demo.zip) binary and give it a try!
* Read the [Make your macOS app themable](https://medium.com/@nfgrilo/make-your-macos-app-themable-30dbfe4f5ef0) article (simple tutorial). 
* Check the [ThemeKit Docs](http://themekit.nunogrilo.com). 

## Table of Contents
* [Summary](#summary)
* [Features](#features)
* [Installation](#installation)
* [Usage](#usage)
  * [Simple Usage](#simple-usage)
  * [Advanced Usage](#advanced-usage)
     * [Observing theme changes](#observing-theme-changes)
     * [Manually theming windows](#manually-theming-windows)
     * [NSWindow extension](#nswindow-extension)
* [Theme-aware Assets](#theme-aware-assets)
* [Creating Themes](#creating-themes)
  * [Native Themes](#native-themes)
  * [User Themes](#user-themes)
* [FAQ](#faq)
* [License](#license)

## Features

- Written in Swift 4.1
- Optional configuration, none required
- Neglected performance impact
- Automatically theme windows (configurable)
- Themes:
  - [`LightTheme`](http://themekit.nunogrilo.com/Classes/LightTheme.html) (default macOS appearance)
  - [`DarkTheme`](http://themekit.nunogrilo.com/Classes/DarkTheme.html)
  - [`SystemTheme`](http://themekit.nunogrilo.com/Classes/SystemTheme.html) (default theme). Dynamically resolves to `ThemeManager.lightTheme` or `ThemeManager.darkTheme`, depending on the *"System Preferences > General > Appearance"*.
  - Support for custom themes ([`Theme`](http://themekit.nunogrilo.com/Protocols/Theme.html))
  - Support for user-defined themes ([`UserTheme`](http://themekit.nunogrilo.com/Classes/UserTheme.html))
- Theme-aware assets:
  - [`ThemeColor`](http://themekit.nunogrilo.com/Classes/ThemeColor.html): colors that dynamically change with the theme
  - [`ThemeGradient`](http://themekit.nunogrilo.com/Classes/ThemeGradient.html): gradients that dynamically change with the theme
  - [`ThemeImage`](http://themekit.nunogrilo.com/Classes/ThemeImage.html): images that dynamically change with the theme
  - Optional override of `NSColor` named colors (e.g., `labelColor`) to dynamically change with the theme

## Installation

|ThemeKit Version|Swift Version|
|----------------|-------------|
|1.0.0           |      3.0    |
|1.1.0           |      4.0    |
|1.2.0           |      4.1    |

There are multiple options to include *ThemeKit* on your project:

- **[CocoaPods](https://cocoapods.org)**

  Add to your `Podfile`:

  ```Podfile
  use_frameworks!
  target '[YOUR APP TARGET]' do
      pod 'macOSThemeKit', '~> 1.2.0'
  end
  ```
  
  When using CocoaPods, the ThemeKit module is named `macOSThemeKit`:
  
  ```
  import macOSThemeKit
  ```
  
  
- **[Carthage](https://github.com/Carthage/Carthage)**

  ```
  github "luckymarmot/ThemeKit"
  ```
  
  Then import ThemeKit module with:
  
  ```
  import ThemeKit
  ```
  
- **Manually**
  - Either add `ThemeKit.framework` on your project, **or**, manually add source files from the `ThemeKit\` folder to your project
  - If importing into a Objective-C project, you will need to include all the Swift related frameworks as well (as reported [here](https://github.com/luckymarmot/ThemeKit/issues/6))
  
  Then import ThemeKit module with:
  
  ```
  import ThemeKit
  ```
  

## Usage

### Simple Usage
At its simpler usage, applications can be themed with a single line command:

##### In Swift:

```swift
func applicationWillFinishLaunching(_ notification: Notification) {
	
	/// Apply the dark theme
	ThemeManager.darkTheme.apply()
	
	/// or, the light theme
	//ThemeManager.lightTheme.apply()
	
	/// or, the 'system' theme, which dynamically changes to light or dark, 
	/// respecting *System Preferences > General > Appearance* setting.
	//ThemeManager.systemTheme.apply()
	
}
```

##### In Objective-C:

```objc
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	
	// Apply the dark theme
	TKDarkTheme *darkTheme = TKThemeManager.darkTheme;
	[[TKThemeManager sharedManager] setTheme:darkTheme];
	
}
```

### Advanced Usage

The following code will define which windows should be automatically themed ([`WindowThemePolicy`](http://themekit.nunogrilo.com/Classes/ThemeManager/WindowThemePolicy.html)) and add support for user themes ([`UserTheme`](http://themekit.nunogrilo.com/Classes/UserTheme.html)):

##### In Swift:

```swift
func applicationWillFinishLaunching(_ notification: Notification) {

	/// Define default theme.
	/// Used on first run. Default: `SystemTheme`.
	/// Note: `SystemTheme` is a special theme that resolves to `ThemeManager.lightTheme` or `ThemeManager.darkTheme`,
	/// depending on the macOS preference at 'System Preferences > General > Appearance'.
	ThemeManager.defaultTheme = ThemeManager.lightTheme
	
	/// Define window theme policy.
	ThemeManager.shared.windowThemePolicy = .themeAllWindows
	//ThemeManager.shared.windowThemePolicy = .themeSomeWindows(windowClasses: [MyWindow.self])
	//ThemeManager.shared.windowThemePolicy = .doNotThemeSomeWindows(windowClasses: [NSPanel.self])
	//ThemeManager.shared.windowThemePolicy = .doNotThemeWindows
	    
	/// Enable & configure user themes.
	/// Will use folder `(...)/Application Support/{your_app_bundle_id}/Themes`.
	let applicationSupportURLs = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
	let thisAppSupportURL = URL.init(fileURLWithPath: applicationSupportURLs.first!).appendingPathComponent(Bundle.main.bundleIdentifier!)
	let userThemesFolderURL = thisAppSupportURL.appendingPathComponent("Themes")
	ThemeManager.shared.userThemesFolderURL = userThemesFolderURL
	
	/// Change the default light and dark theme, used when `SystemTheme` is selected.
	//ThemeManager.lightTheme = ThemeManager.shared.theme(withIdentifier: PaperTheme.identifier)!
	//ThemeManager.darkTheme = ThemeManager.shared.theme(withIdentifier: "com.luckymarmot.ThemeKit.PurpleGreen")!
	
	/// Apply last applied theme (or the default theme, if no previous one)
	ThemeManager.shared.applyLastOrDefaultTheme()
	 
}    
```

##### In Objective-C:

```objc
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {

    /// Define default theme.
    /// Used on first run. Default: `SystemTheme`.
    /// Note: `SystemTheme` is a special theme that resolves to `ThemeManager.lightTheme` or `ThemeManager.darkTheme`,
    /// depending on the macOS preference at 'System Preferences > General > Appearance'.
    [TKThemeManager setDefaultTheme:TKThemeManager.lightTheme];
    
    /// Define window theme policy.
    [TKThemeManager sharedManager].windowThemePolicy = TKThemeManagerWindowThemePolicyThemeAllWindows;
    //[TKThemeManager sharedManager].windowThemePolicy = TKThemeManagerWindowThemePolicyThemeSomeWindows;
    //[TKThemeManager sharedManager].themableWindowClasses = @[[MyWindow class]];
    //[TKThemeManager sharedManager].windowThemePolicy = TKThemeManagerWindowThemePolicyDoNotThemeSomeWindows;
    //[TKThemeManager sharedManager].notThemableWindowClasses = @[[NSPanel class]];
    //[TKThemeManager sharedManager].windowThemePolicy = TKThemeManagerWindowThemePolicyDoNotThemeWindows;
    
    /// Enable & configure user themes.
    /// Will use folder `(...)/Application Support/{your_app_bundle_id}/Themes`.
    NSArray<NSString*>* applicationSupportURLs = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSURL* thisAppSupportURL = [[NSURL fileURLWithPath:applicationSupportURLs.firstObject] URLByAppendingPathComponent:[NSBundle mainBundle].bundleIdentifier];
    NSURL* userThemesFolderURL = [thisAppSupportURL URLByAppendingPathComponent:@"Themes"];
    [TKThemeManager sharedManager].userThemesFolderURL = userThemesFolderURL;
    
    /// Change the default light and dark theme, used when `SystemTheme` is selected.
    //TKThemeManager.lightTheme = [[TKThemeManager sharedManager] themeWithIdentifier:PaperTheme.identifier];
    //TKThemeManager.darkTheme = [[TKThemeManager sharedManager] themeWithIdentifier:@"com.luckymarmot.ThemeKit.PurpleGreen"];
    
    /// Apply last applied theme (or the default theme, if no previous one)
    [[TKThemeManager sharedManager] applyLastOrDefaultTheme];
    
}
```

Please check the **Demo** application source code for a more complete usage example of *ThemeKit*.

#### Observing theme changes

ThemeKit provides the following notifications:

- `Notification.Name.willChangeTheme` is sent when current theme is about to change
- `Notification.Name.didChangeTheme` is sent when current theme did change
- `Notification.Name.didChangeSystemTheme` is sent when system theme did change (System Preference > General)

Example:

```swift
// Register to be notified of theme changes
NotificationCenter.default.addObserver(self, selector: #selector(changedTheme(_:)), name: .didChangeTheme, object: nil)

@objc private func changedTheme(_ notification: Notification) {
	// ...
}
```

Additionally, the following properties are KVO compliant:

- [`ThemeManager.shared.theme`](http://themekit.nunogrilo.com/Classes/ThemeManager.html#/s:vC8ThemeKit12ThemeManager5themePS_5Theme_)
- [`ThemeManager.shared.effectiveTheme`](http://themekit.nunogrilo.com/Classes/ThemeManager.html#/s:vC8ThemeKit12ThemeManager14effectiveThemePS_5Theme_)
- [`ThemeManager.shared.themes`](http://themekit.nunogrilo.com/Classes/ThemeManager.html#/s:vC8ThemeKit12ThemeManager6themesGSaPS_5Theme__)
- [`ThemeManager.shared.userThemes`](http://themekit.nunogrilo.com/Classes/ThemeManager.html#/s:vC8ThemeKit12ThemeManager10userThemesGSaPS_5Theme__)

Example:

```swift
// Register for KVO changes on ThemeManager.shared.effectiveTheme
ThemeManager.shared.addObserver(self, forKeyPath: "effectiveTheme", options: NSKeyValueObservingOptions.init(rawValue: 0), context: nil)

public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
	if keyPath == "effectiveTheme" {
		// ...
   }
}
```


#### Manually theming windows

In case ([`WindowThemePolicy`](http://themekit.nunogrilo.com/Classes/ThemeManager/WindowThemePolicy.html)) was NOT set to `.themeAllWindows`, you may need to manually theme a window. You can use our `NSWindow` extension for that:

##### [NSWindow Extension](http://themekit.nunogrilo.com/Extensions/NSWindow.html)

- [`NSWindow.theme()`](http://themekit.nunogrilo.com/Extensions/NSWindow.html#/s:FE8ThemeKitCSo8NSWindow5themeFT_T_)

	Theme window if appearance needs update. Doesn't check for policy compliance.

- [`NSWindow.themeIfCompliantWithWindowThemePolicy()`](http://themekit.nunogrilo.com/Extensions/NSWindow.html#/s:FE8ThemeKitCSo8NSWindow37themeIfCompliantWithWindowThemePolicyFT_T_)

	Theme window if compliant to `ThemeManager.shared.windowThemePolicy` (and if appearance needs update).

- [`NSWindow.themeAllWindows()`](http://themekit.nunogrilo.com/Extensions/NSWindow.html#/s:ZFE8ThemeKitCSo8NSWindow15themeAllWindowsFT_T_)

	Theme all windows compliant to `ThemeManager.shared.windowThemePolicy` (and if appearance needs update).
	
- [`NSWindow.windowTheme`](http://themekit.nunogrilo.com/Extensions/NSWindow.html#/s:vE8ThemeKitCSo8NSWindow11windowThemeGSqPS_5Theme__)

	Any window specific theme.
   This is, usually, `nil`, which means the current global theme will be used.
   Please note that when using window specific themes, only the associated `NSAppearance` will be automatically set. All theme aware assets (`ThemeColor`, `ThemeGradient` and `ThemeImage`) should call methods that returns a resolved color instead (which means they don't change with the theme change, you need to observe theme changes manually, and set colors afterwards):

   	- `ThemeColor.color(for view:, selector:)`
   	- `ThemeGradient.gradient(for view:, selector:)`
   	- `ThemeImage.image(for view:, selector:)`

   	Additionally, please note that system overridden colors (`NSColor.*`) will always use the global theme.

- [`NSWindow.windowEffectiveTheme`](http://themekit.nunogrilo.com/Extensions/NSWindow.html#/s:vE8ThemeKitCSo8NSWindow20windowEffectiveThemePS_5Theme_)

	Returns the current effective theme (read-only).

- [`NSWindow.windowEffectiveThemeAppearance`](http://themekit.nunogrilo.com/Extensions/NSWindow.html#/s:vE8ThemeKitCSo8NSWindow30windowEffectiveThemeAppearanceGSqCSo12NSAppearance_)

	Returns the current effective appearance (read-only).


## Theme-aware Assets

[`ThemeColor`](http://themekit.nunogrilo.com/Classes/ThemeColor.html), [`ThemeGradient`](http://themekit.nunogrilo.com/Classes/ThemeGradient.html) and [`ThemeImage`](http://themekit.nunogrilo.com/Classes/ThemeImage.html) provides colors, gradients and images, respectively, that dynamically change with the current theme.

Additionally, named colors from the `NSColor` class defined on the `ThemeColor` subclass extension will override the system ones, providing theme-aware colors.

For example, a project defines a `ThemeColor.brandColor` color. This will resolve to different colors at runtime, depending on the selected theme:

- `ThemeColor.brandColor` will resolve to `NSColor.blue` if the light theme is selected
- `ThemeColor.brandColor` will resolve to `NSColor.white` if the dark theme is selected
- `ThemeColor.brandColor` will resolve to `rgba(100, 50, 0, 0.5)` for some user-defined theme ([`UserTheme`](http://themekit.nunogrilo.com/Classes/UserTheme.html))

Similarly, defining a `ThemeColor.labelColor` will override `NSColor.labelColor` (`ThemeColor` is a subclass of `NSColor`), and *ThemeKit* will allow `labelColor` to be customized on a per-theme basis as well. 

The [NSColor Extension](http://themekit.nunogrilo.com/Extensions/NSColor.html) may be useful when overriding colors in ThemeColor extensions.

### Fallback Assets

ThemeKit provides a simple fallback mechanism when looking up assets in the current theme. It will search for assets, in order:

- the asset name, defined in theme (e.g., `myBackgroundColor`)
- `fallbackForegroundColor`, `fallbackBackgroundColor`, `fallbackGradient` or `fallbackImage` defined in theme, depending if asset is a foreground/background color, gradient or image, respectively
- `defaultFallbackForegroundColor`, `defaultFallbackBackgroundColor`, `fallbackGradient` or `defaultFallbackImage` defined internally, depending if asset is a foreground/background color, gradient or image, respectively

However, for overridden system named colors, the fallback mechanism is different and simpler:

- the asset name, defined in theme (e.g., `labelColor`)
- original asset defined in the system (e.g., `NSColor.labelColor`)

Please refer to [`ThemeColor`](http://themekit.nunogrilo.com/Classes/ThemeColor.html), [`ThemeGradient`](http://themekit.nunogrilo.com/Classes/ThemeGradient.html) and [`ThemeImage`](http://themekit.nunogrilo.com/Classes/ThemeImage.html) for more information.

## Creating Themes

### Native Themes
For creating additional themes, you only need to create a class that conforms to the [`Theme`](http://themekit.nunogrilo.com/Protocols/Theme.html) protocol and extends `NSObject`.

Sample theme:

```swift
import Cocoa
import ThemeKit
	
class MyOwnTheme: NSObject, Theme {
    
    /// Light theme identifier (static).
    public static var identifier: String = "com.luckymarmot.ThemeKit.MyOwnTheme"
    
    /// Unique theme identifier.
    public var identifier: String = MyOwnTheme.identifier
    
    /// Theme display name.
    public var displayName: String = "My Own Theme"
    
    /// Theme short display name.
    public var shortDisplayName: String = "My Own"
    
    /// Is this a dark theme?
    public var isDarkTheme: Bool = false
    
    /// Description (optional).
    public override var description : String {
        return "<\(MyOwnTheme.self): \(themeDescription(self))>"
    }
    
    // MARK: -
    // MARK: Theme Assets
    
    // Here you can define the instance methods for the class methods defined 
    // on `ThemeColor`, `ThemeGradient` and `ThemeImage`, if any. Check
    // documentation of these classes for more details.
}
```

### User Themes
ThemeKit also supports definition of additional themes with simple text files (`.theme` files). Example of a very basic `.theme` file:

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
# define image using named image "apple"
namedImage = image(named:apple)
# define image using from filesystem (relative to user themes folder)
fileImage = image(file:../some/path/some-file.jpg)

// *********************** Common Colors ************************ //
blue = rgb(0, 170, 255)
orange.sky = rgb(160, 90, 45, .5)

// ********************** Fallback Assets *********************** //
fallbackForegroundColor = rgb(255, 10, 90, 1.0)
fallbackBackgroundColor = rgb(255, 200, 190)
fallbackGradient = linear-gradient($blue, rgba(200, 140, 60, 1.0))

```

To enable support for user themes, just need to set the location for them:

```swift
// Setup ThemeKit user themes folder
ThemeManager.shared.userThemesFolderURL = //...
```

Please refer to [`UserTheme`](http://themekit.nunogrilo.com/Classes/UserTheme.html) for more information.


## FAQ

### **Where can I find the API documentation?**
Documentation can be found [here](http://themekit.nunogrilo.com). You can also [install it](dash-feed://http%3A%2F%2Fthemekit%2Enunogrilo%2Ecom%2Fdocsets%2FThemeKit%2Exml) on [Dash](https://kapeli.com/dash).

### **Can the window titlebar/toolbar/tabbar be themed?**
Yes - please check one way to do it on the [Demo project](https://github.com/luckymarmot/ThemeKit/tree/master/Demo).
Basically, a [TitleBarOverlayView](https://github.com/luckymarmot/ThemeKit/blob/master/Demo/Demo/TitleBarOverlayView.swift) view is added *below* the window title bar, [as shown on the WindowController](https://github.com/luckymarmot/ThemeKit/blob/master/Demo/Demo/WindowController.swift#L45-L82) controller.

### **Can controls be tinted with different colors?**
Other than the colors set by the inherited appearance - light (dark text on light background) or dark (light text on dark background) - natively, it is not possible to specify different colors for the text and/or background fills of controls (buttons, popups, etc).

For simple cases, overriding `NSColor` can be sufficient: for example, `NSColor.labelColor` is a named color used for text labels; overriding it will allow to have all labels themed accordingly. You can get a list of all overridable named colors (class method names) with `NSColor.colorMethodNames()`.

For more complex cases, like views/controls with custom drawing, please refer to next question.

### **Can I make custom drawing views/controls theme-aware?**
Yes, you can! Implement your own custom controls drawing using [Theme-aware Assets](#theme-aware-assets) (`ThemeColor` and `ThemeGradient`) so that your controls drawing will always adapt to your current theme... automatically!

In case needed (for example, if drawing is being cached), you can observe when theme changes to refresh the UI or to perform any theme related operation. Check *"Observing theme changes"* on [Usage](#usage) section above.

### **NSTableView cells are getting a background color after being themed!**
Please check [this issue](https://github.com/luckymarmot/ThemeKit/issues/18). This theming issue only affects view-based `NSTableView`s, when placed on sheets, on macOS < 10.14. Please check [this comment](https://github.com/luckymarmot/ThemeKit/issues/18#issuecomment-396553982) for a brief explanation on how to fix it, and a small project demonstrating the issue and the fix.


### **Scrollbars appear all white on dark themes!**
If the user opts for always showing the scrollbars on *System Preferences*, scrollbars may render all white on dark themes. To bypass this, we need to observe for theme changes and change its background color directly. E.g.,

   ```swift
   scrollView?.backgroundColor = ThemeColor.myBackgroundColor
   scrollView?.wantsLayer = true
   NotificationCenter.default.addObserver(forName: .didChangeTheme, object: nil, queue: nil) { (note) in
     scrollView?.verticalScroller?.layer?.backgroundColor = ThemeColor.myBackgroundColor.cgColor
   }
   ```

### **I'm having font smoothing issues!**
You may run into font smoothing issues when you use text without a background color set. Bottom line is, always specify/draw a background when using/drawing text. 

   1. For controls like `NSTextField`, `NSTextView`, etc:
   
        Specify a background color on the control. E.g.,

        ```swift
        control.backgroundColor = NSColor.black
        ```

  2. For custom text rendering:

        First draw a background fill, then enable font smoothing and render your text. E.g.,

        ```swift
        let context = NSGraphicsContext.current()?.cgContext
        NSColor.black.set()
        context?.fill(frame)
        context?.saveGState()
        context?.setShouldSmoothFonts(true)
        
        // draw text...
        
        context?.restoreGState()
        ```

        As a last solution - if you really can't draw a background color - you can disable font smoothing which can slightly improve text rendering:

        ```swift
        let context = NSGraphicsContext.current()?.cgContext
        context?.saveGState()
        context?.setShouldSmoothFonts(false)
        
        // draw text...
        
        context?.restoreGState()
        ```

  3. For custom `NSButton`'s:

        This is more tricky, as you will need to override private methods. If you are distributing your app on the Mac App Store, you must first check if this is allowed.
    
        a) override the private method `_backgroundColorForFontSmoothing` to return your button background color.
    
        b) if (a) isn't sufficient, you will also need to override `_textAttributes` and change the dictionary returned from the `super` call to provide your background color for the key `NSBackgroundColorAttributeName`.



## License

*ThemeKit* is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

