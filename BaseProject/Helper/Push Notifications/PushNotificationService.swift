//
//  PushNotificationService.swift
//  MtoM
//
//  Created by nguyen van dung on 12/16/15.
//  Copyright © 2015 Framgia. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase

class PushNotificationService: NSObject {
    static let shared = PushNotificationService()

    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    func unRegisterRemoteNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func requestRemoteNotificationAuthorization(_ completion: ((Bool) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { granted, error in
            if let _ = error {
                return
            }
            
            DispatchQueue.main.async(execute: {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion?(granted)
            })
        })
    }
    
    func didRegisterForRemoteNotificationsWithDeviceToken(_ application: UIApplication, deviceToken: Data) {
        let desc = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        let deviceTokenString = desc.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        let newToken = deviceTokenString.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        if !newToken.isEmpty {
            print(newToken)
        }
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        self.processContentOfRemoteNotification(userInfo, isoffline: true)
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ application: UIApplication, error: Error) {
        print("!!!!!failed to register notification!!!!! : \(error)")
    }
    
    func isAppActive() -> Bool {
        let state: UIApplicationState = UIApplication.shared.applicationState
        return state == UIApplicationState.active
    }
    
    func processContentOfRemoteNotification(_ payload: [AnyHashable: Any], isoffline: Bool) {
        print(payload)
        
        let alert = UIAlertController(title: "", message: payload.description, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    }

    /*
     - This process for notification receiced when app do not open
     */
    func processOffNotificationPayload(_ notificationObj: [AnyHashable: Any]?) {
        if let info = notificationObj {
            self.processContentOfRemoteNotification(info, isoffline: false)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        completionHandler([.alert, .sound])
        self.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        let userInfo = response.notification.request.content.userInfo
        self.didReceiveRemoteNotification(userInfo: userInfo)
        completionHandler()
    }
}
