//
//  Student.swift
//  BaseProject
//
//  Created by MTQ on 10/26/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct Student {
    var id: Int = 0
    var name: String = ""
}

extension Student: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
