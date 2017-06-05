# Bagel
Bagel is native iOS network sniffer. It's not a proxy debugger so you don't have to mess with certificates, secure connections etc. Bagel is aimed to provide network debugging with multiple projects and devices at the same time. You can see network traffic of your app seperated by the devices. To connect your project you need to install iOS SDK of Bagel and download macOS client.

### macOS Client
Bagel macOS client is also native and maintained actively. You can download it from here.

### Preview
![](http://yagiz.me/wp-content/uploads/2017/06/Screen-Shot-2017-06-05-at-20.43.17.png)
If you are here for the macOS client, you can download it from here.
### Installation

#### CocoaPods
```sh
pod 'Bagel'
```
#### Manually
Just download or clone the repo and move Classes folder to your project.

### Usage
You can init a new ScreeshotSharer instance to register a view or window to be captured. 

#### Capturing a View
```swift
Bagel.shared().start()
```
```swift
[[Bagel shared] start()];
```

#### Capturing Whole Screen
```swift
sssharer.registerScreenCapturer(cropStatusBar: true, cropRect: CGRect.zero, captureBlock: { (image, screenshotSharerViewController) in

    //this block is called when the user takes a screenshot
    //image is the image of given view and it can be cropped according to cropRect.
    //sharerViewController is the presented view controller
    
}) { (isSuccess) in
            
    //this block is called when sharerViewController is dismissed
    //isSuccess indicates if sharing is completed successfully.
}
```

#### Customizing Default Sharer View Controller 
By default ScreenshotSharer uses ScreenshotSharerMinimal as the presented sharer view controller. You can customize it in the captureBlock:
```swift
sssharer.registerScreenCapturer(cropStatusBar: true, cropRect: CGRect.zero, captureBlock: { (image, screenshotSharerViewController) in
            
    if let sharerViewController = sharerViewController
    {
        sharerViewController.view.backgroundColor = UIColor.red
        sharerViewController.setShareTitleText(_ text: String)
        sharerViewController.setShareTitleFont(_ font: UIFont)
        sharerViewController.setShareTitleColor(_ color: UIColor)
    }
    
}) { (isSuccess) in

}
```
These are the all the methods you can use to customize default sharer view controller:
```swift
func setShareTitleText(_ text:String)
func setShareDescriptionText(_ text:String)
func setShareButtonTitleText(_ text:String)

func setShareTitleFont(_ font:UIFont)
func setShareDescriptionFont(_ font:UIFont)
func setShareButtonTitleFont(_ font:UIFont)
    
func setShareTitleTextColor(_ color:UIColor)
func setShareDescriptionTextColor(_ color:UIColor)
func setShareButtonTitleColor(_ color:UIColor)
func setShareButtonBackgroundColor(_ color:UIColor)
```
#### Designing Your Own Sharer View Controller
In some cases you may want to design the whole sharer view controller from stratch. To do this your sharer view controller should extend ScreenshotSharerViewController class and you should register it to ScreenshotSharer instance. Default sharer view controller uses UIActivityViewController but you can implement your own share logic.
```swift
let customSharer = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomSharerViewController") as! CustomSharerViewController
        
sssharer.registerScreenCapturer(cropStatusBar: true, cropRect: CGRect.zero, sharerViewController: customSharer, captureBlock: { (image, customScreenshotSharerViewController) in

}) { (isSuccess) in
            
}
```
You can use the ScreenshotSharerMinimal.swift and ScreenshotSharerMinimal.xib files as your base design. ScreenshotSharer will present your own view controller and call this method:
```swift
func setScreenshotImage(_ image:UIImage)
```
Therefore you should implement ```setScreenshotImage(_ image:UIImage)``` method. When you want to dismiss the sharer view controller you should call this method in your own sharer view controller:
```swift
self.screenshotSharer().dismissSharerViewController(isSuccess)
```
```isSuccess``` indicates that sharing is completed successfully.

License
----
MIT

**Free Software, Hell Yeah!**