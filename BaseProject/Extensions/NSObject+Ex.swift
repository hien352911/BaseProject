//
//  NSObject.swift
//  BaseProject
//
//  Created by MTQ on 5/10/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        get {
            return NSStringFromClass(self).components(separatedBy: ".").last!
        }
    }
    
    var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
}
