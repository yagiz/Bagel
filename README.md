# Bagel
![Bagel](https://github.com/yagiz/Bagel/blob/master/assets/header.png?raw=true)
<p align="center">
    <a href="https://github.com/CocoaPods/CocoaPods" alt="CocoaPods">
        <img src="https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat" /></a>
    <a href="https://github.com/Carthage/Carthage" alt="Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" /></a>
    <a href="https://github.com/yagiz/Bagel/releases/tag/1.3.1" alt="Version">
        <img src="https://img.shields.io/badge/version-1.3.1-blue.svg?style=flat" /></a>
</p>

Bagel is a little native iOS network debugger. It's not a proxy debugger so you don't have to mess around with certificates, proxy settings etc. As long as your iOS devices and your Mac are in the same network, you can view the network traffic of your apps seperated by the devices or simulators.

## Preview
![Bagel](https://github.com/yagiz/Bagel/blob/develop/assets/screenshot.png?raw=true)
## Installation
#### Install Mac App
- Clone the repo.
- Install pods.
- Build and archive the project.
#### Install iOS Client
#### CocoaPods
```sh
pod 'Bagel', '~>  1.3.2'
```
##### Carthage
```sh
github "yagiz/Bagel" "1.3.2"
```

### Usage
Most basic usage is to start Bagel iOS before any network operation. 
```swift
//import Bagel
Bagel.start()
```
Since Bagel exposes every request info to the public it would be better if you disable it for the store versions. You can use the below snippet to do it:
```swift
//import Bagel
#if DEBUG
Bagel.start()
#endif
```

###  Configuring Bagel
By default, Bagel gets your project name and device information. Desktop client uses these informations to separate projects and devices. You can configure these if you wish:
```swift
let bagelConfig = BagelConfiguration()

bagelConfig.project.projectName = "Custom Project Name"
bagelConfig.device.deviceName = "Custom Device Name"
bagelConfig.device.deviceDescription = "Custom Device Description"

Bagel.start(bagelConfig)
```
Bagel framework communicates with the desktop client by using Bonjour protocol. You can also configure these Netservice parameters. Default values are:

```swift
let bagelConfig = BagelConfiguration()

bagelConfig.netservicePort = 43434
bagelConfig.netserviceDomain = ""
bagelConfig.netserviceType = "_Bagel._tcp"
bagelConfig.netserviceName = ""

Bagel.start(bagelConfig)
```
If you change Netservice parameters in your app, you should also change them on desktop client.

License
----
Apache
