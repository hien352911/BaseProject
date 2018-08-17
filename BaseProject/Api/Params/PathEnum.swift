//
//  PathEnum.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation

let rootURL = "https://api.darksky.net/forecast/41cd0425a6fadf7a97e633f522f148dd/37.8267,-122.4233"

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
