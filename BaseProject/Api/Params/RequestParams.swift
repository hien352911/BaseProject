//
//  RequestParams.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation

class RequestParams: NSObject {
    var params = [String: Any]()
    var bodyDatas = [RequestBodyData]()

    func addBodyData(bodyData: RequestBodyData) {
        bodyDatas.append(bodyData)
    }

    override func setValue(_ value: Any?, forKey key: String) {
        if let vl = value {
            params[key] = vl
        }
    }

    func hasBodyDataNeedConstruct() -> Bool {
        return (bodyDatas.count > 0)
    }

    func origin() -> [String : Any] {
        return params
    }

    class func defaultLoginParams() -> RequestParams {
        let param = RequestParams()
        return param
    }
}
