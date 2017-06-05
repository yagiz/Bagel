# Bagel
Bagel is a native iOS network sniffer. It's not a proxy debugger so you don't have to mess with certificates, proxy settings etc. As long as your devices and your Mac in the same network you can view network traffic of your app or apps seperated by the devices. 

### Preview
![](http://yagiz.me/wp-content/uploads/2017/06/Screen-Shot-2017-06-05-at-20.43.17.png)
If you are here for the macOS client, you can download it from here.
### Installation
To connect your app you need to install iOS SDK of Bagel to sniff and download macOS client to view network traffic of it.
#### CocoaPods
```sh
pod 'Bagel'
```
#### Manually
Just download or clone the repo and move Bagel.framework into your project.

### Usage
Most basic usage is to start Bagel framework before any operation that sends requests. 
```swift
//import Bagel
Bagel.shared().start()
```

#### Configuring Bagel
By default, Bagel gets your project name and device information. Desktop client uses these informations to seperate projects and apps. You can configure these easly:
```swift
let bagelConfig = BagelConfiguration()
bagelConfig.project.projectName = "Custom Project Name"
bagelConfig.device.deviceName = "Custom Device Name"
bagelConfig.device.deviceDescription = "Custom Device Description"

Bagel.shared().startWithConfiguration(bagelConfig)
```
Bagel framework communicates with desktop client through Bounjour protocol. You can also configure these Netservice parameters. Default values are:
```swift
let bagelConfig = BagelConfiguration()
bagelConfig.netservicePort = 43434
bagelConfig.netserviceDomain = "_Bagel._tcp"
bagelConfig.netserviceType = ""
bagelConfig.netserviceName = ""

Bagel.shared().startWithConfiguration(bagelConfig)
```
If you change Netservice parameters in your app, you should also change them on desktop client.

License
----
MIT

**Free Software, Hell Yeah!**