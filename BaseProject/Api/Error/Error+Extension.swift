//
//  Error+Extension.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation

extension Error {
    func nserror() -> NSError {
        return ((self as Any) as? NSError) ?? NSError(domain: "Unknown error", code: 900, userInfo: nil)
    }
}
