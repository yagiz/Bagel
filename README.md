# Bagel
![Bagel](https://github.com/yagiz/Bagel/blob/master/assets/header.png?raw=true)

Bagel is a little native iOS network debugger. It's not a proxy debugger so you don't have to mess around with certificates, proxy settings etc. As long as your iOS devices and your Mac are in the same network, you can view the network traffic of your apps seperated by the devices. 

## Preview
![Bagel](https://github.com/yagiz/Bagel/blob/develop/assets/screenshot.png?raw=true)
## Installation
#### Install Mac App
- Clone the repo.
- Build and archive the project.
#### Install iOS Client
##### CocoaPods
Currently best way to install Bagel is to use Cocoapods.
```sh
pod 'Bagel'
```

### Usage
Most basic usage is to start Bagel iOS before any network operation. 
```swift
//import Bagel
Bagel.start()
```

###  Configuring Bagel
By default, Bagel gets your project name and device information. Desktop client uses these informations to separate projects and devices. You can configure these if you wish:
```swift
let bagelConfig = BagelConfiguration()

bagelConfig.project.projectName = "Custom Project Name"
bagelConfig.device.deviceName = "Custom Device Name"
bagelConfig.device.deviceDescription = "Custom Device Description"

Bagel.start(configuration: bagelConfig)
```
Bagel framework communicates with the desktop client by using Bounjour protocol. You can also configure these Netservice parameters. Default values are:

```swift
let bagelConfig = BagelConfiguration()

bagelConfig.netservicePort = 43434
bagelConfig.netserviceDomain = "_Bagel._tcp"
bagelConfig.netserviceType = ""
bagelConfig.netserviceName = ""

Bagel.start(configuration: bagelConfig)
```
If you change Netservice parameters in your app, you should also change them on desktop client.

License
----
Apache
