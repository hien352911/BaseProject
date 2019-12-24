//
//  Default.swift
//  Motorbike
//
//  Created by seesaa on 6/2/19.
//  Copyright © 2019 MTQ. All rights reserved.
//

import Foundation

enum Defaults: String {
    case dateLastRequestFirebase = "dateLastRequestFirebase"
    case userInfo = "userInfo"
    
    func set(value: Any?) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func get() -> Any? {
        return UserDefaults.standard.object(forKey: self.rawValue)
    }
    
    func getBool() -> Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
    
    func getString() -> String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }
    
    func getStringOrEmpty() -> String {
        return self.getString() ?? ""
    }
    
    func getInt() -> Int? {
        return UserDefaults.standard.integer(forKey: self.rawValue)
    }
    
    func getDate() -> Date? {
        return UserDefaults.standard.date(forKey: self.rawValue)
    }
    
    func getDict() -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: self.rawValue)
    }
}
