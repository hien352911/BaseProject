# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BaseProject' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BaseProject
pod 'Alamofire'
pod 'SDWebImage'
pod 'RxSwift'
pod 'RxCocoa'
pod 'NVActivityIndicatorView'
pod 'SwifterSwift'
pod 'ReachabilitySwift'
pod 'SwiftDate'
#Keyboard
pod 'IQKeyboardManagerSwift'
#Database
pod 'Realm'
pod 'RealmSwift'
#Firebase Push Notification
pod 'Firebase/Core'
pod 'Firebase/Messaging'
#Parse Json
pod 'ObjectMapper'
#Side Menu
pod 'SideMenu'
#Map
pod 'INTULocationManager'
#Pull To Refresh
pod 'ESPullToRefresh'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
