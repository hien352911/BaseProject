//
//  AppDelegate.swift
//  BaseProject
//
//  Created by MTQ on 7/26/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var realm: Realm!
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Remote Notification
        registerRemoteNotification()
        FCM.shared.setup()
        // Realm
        configureRealm()
        // KeyboardManager
        setupKeyboardManager()
        
        return true
    }
    
    //MARK: -remote notification
    func registerRemoteNotification() {
        PushNotificationService.shared.requestRemoteNotificationAuthorization()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenRefreshNotificaiton(notify:)),
                                               name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
    }
    
    @objc func tokenRefreshNotificaiton(notify: Notification) {
        FCM.shared.tokenRefreshNotificaiton()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotificationService.shared.didReceiveRemoteNotification(userInfo: userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if DEBUG
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
        #endif
        PushNotificationService.shared.didRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
        PushNotificationService.shared.didFailToRegisterForRemoteNotificationsWithError(application, error: error)
    }
    
    // MARK: - Deep link
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var schemes = [String]()
        
        if let bundleURLTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [NSDictionary] {
            for bundleURLType in bundleURLTypes {
                if let scheme = bundleURLType["CFBundleURLSchemes"] {
                    if let streamArray = scheme as? [String] {
                        schemes += streamArray
                    }
                }
            }
        }
        
        schemes = schemes.map({ (s) -> String in
            return s.lowercased()
        })
        
        if ("error" == url.host) {
            print("error")
            return false
        }
        
        guard schemes.contains((url.scheme?.lowercased())!) else {
            print("unknown")
            return false
        }
        
        let paths = url.pathComponents
        
        guard paths.count > 0 else {
            print("invalid url path")
            return false
        }
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        
        /**
         * Format: mgdeeplink://products/detail?id=iphone
         * scheme: đã đăng ký ở Targets -> Info -> URL Types để iOS biết sẽ dùng app nào để mở 1 loại url cụ thể
         * host: đại diện cho website, tên server của bạn trên web, 1 app có thể đối ứng với nhiều loại host
         * path: cho phép chúng ta truyền thêm các tham số
         */
        if paths.count == 2 {
            if paths[1] == "detail" {
                if let queryItems = urlComponents?.queryItems, queryItems.count == 1 &&
                    queryItems[0].name == "id"
                {
                    if let id = queryItems[0].value {
                        showProduct(id: id)
                    }
                }
            }
        }
        
        return true
    }
    
    func showProduct(id: String) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as? UIViewController {
            let nav = UINavigationController(rootViewController: vc)
            
            self.window?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - Configure Realm
    func configureRealm() {
        let schemaVersion = 2
        let destinatation = Utilities.documentPath! + "/data"
        if FileManager.default.fileExists(atPath: destinatation) == false {
            if let path = Bundle.main.path(forResource: "data", ofType: "") {
                if FileManager.default.fileExists(atPath: path) {
                    do {
                        try FileManager.default.copyItem(atPath: path, toPath: destinatation)
                    } catch {
                        
                    }
                }
            }
        }
        let url = URL(fileURLWithPath: destinatation)
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: UInt64(schemaVersion),
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < schemaVersion) {
                    /** if just the name of your model's property changed you can do this
 
                    migration.renameProperty(onType: Person.className(), from: "name", to: "fullname")
                    */
                    
                    /** if you want to fill a new property with some values you have to enumerate
                     the existing objects and set the new value
                     
                     migration.enumerateObjects(ofType: Person.className(), { (oldObject, newObject) in
                     let firstName = oldObject!["firstName"] as! String
                     let lastName = oldObject!["lastName"] as! String
                     newObject!["fullname"] = firstName + " " + lastName
                     })
                     */
                }
        })
        config.fileURL = url
        Realm.Configuration.defaultConfiguration = config
        realm = try? Realm()
    }
    
    // MARK: - Setup NavigationBar
    private func setupNavigationBar() {
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "ic_navbar_back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_navbar_back")
        UINavigationBar.appearance().tintColor = UIColor.default
        UINavigationBar.appearance().setTitleColor(UIColor.default)
    }
    
    // MARK: - Setup KeyboardManager
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - Get CurrentLocation
    private func getCurrentLocation() {
        let locMgr = INTULocationManager.sharedInstance()
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.city, timeout: 10, delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            if status == .success {
                LocationManager.shared.reverseGeocodeLocationWithCoordinates(currentLocation!, onReverseGeocodingCompletionHandler: { (dict, placemark, text) in
                    var address = ""
                    if let subLocality = placemark?.subLocality {
                        address = subLocality + ", "
                    }
                    if let locality = placemark?.locality {
                        address += "\(locality), "
                    }
                    if let country = placemark?.country {
                        address += "\(country)"
                    }
                    UserManager.shared.address = address
                    NotificationCenter.default.post(name: NSNotification.Name("updateAddress"), object: nil, userInfo: ["address": UserManager.shared.address])
                })
            }
        }
    }
}
