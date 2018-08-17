//
//  RequestBodyData.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation

class RequestBodyData: NSObject {
    var data: Data?
    var name: String?

    convenience init(name: String?, data: Data) {
        self.init()
        self.name = name
        self.data = data
    }

    func isFileData() -> Bool {
        return false
    }
}
