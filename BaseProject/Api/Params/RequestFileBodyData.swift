//
//  RequestFileBodyData.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation

class RequestFileBodyData: RequestBodyData {
    var mineType = ""
    var filename = ""
    
    public convenience init(name: String?, data: Data, mintype: String?, filename: String?) {
        self.init()
        self.name = name
        self.data = data
        self.mineType = mintype ?? ""
        self.filename = filename ?? ""
    }
    
    override open func isFileData() -> Bool {
        return true
    }
}
