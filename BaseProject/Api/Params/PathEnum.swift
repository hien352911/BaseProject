//
//  PathEnum.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation

let rootURL = "http://www.mocky.io/v2/5bd296f33400007000cfddc7"

enum Path {
    case getWeathers

    private var relativePath: String {
        switch self {
        case .getWeathers:
            return ""
        }
    }

    var path: String {
        return (NSURL(string: rootURL)?.appendingPathComponent(relativePath)?.absoluteString) ?? ""
    }
}
