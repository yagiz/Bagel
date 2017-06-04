
Pod::Spec.new do |s|
  s.name             = 'Bagel'
  s.version          = '0.0.3'
  s.summary          = 'iOS SDK for Bagle native iOS network debugging tool'
 
  s.description      = <<-DESC
SSSharer is a little Swift 3.0 pod that enables users to share screenshot image quickly. It's inspired from Asos app. It's highly customizable. You can even design your own ViewController(XIB,Storyboard or pure by code) and use it as a sharer view.
                       DESC
 
  s.homepage         = 'https://github.com/yagiz/Bagel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yagiz' => 'yagizgurgul@gmail.com' }
  s.source           = { :git => 'https://github.com/yagiz/Bagel.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  
  s.vendored_frameworks = 'Bagel.framework'
  
  s.dependency 'CocoaAsyncSocket'
  
  s.frameworks = 'Foundation', 'UIKit'
  
  s.requires_arc = true
  
end
