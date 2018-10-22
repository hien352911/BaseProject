//
//  FCM.swift
//  Mei_messaging
//
//  Created by Nguyen Van Dung on 4/23/18.
//  Copyright © 2018 TSpace. All rights reserved.
//

import Foundation
import Firebase

class FCM: NSObject {
    static let shared = FCM()
    
    var fcmToken = ""

    func setup() {
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            if let firebaseOption = FirebaseOptions(contentsOfFile: filePath) {
                FirebaseApp.configure(options: firebaseOption)
            }
        }
    }

    func tokenRefreshNotificaiton() {
        guard let refreshedToken = InstanceID.instanceID().token() else {
            return
        }
        print("==================================")
        print("FCMToken: \(refreshedToken)")
        print("==================================")
    
        self.fcmToken = refreshedToken
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
}
