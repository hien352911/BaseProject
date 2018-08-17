//
//  Encoding.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation
import Alamofire

class Encoding: NSObject {
    class func forMethod(method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return URLEncoding.default
        }
    }
}
