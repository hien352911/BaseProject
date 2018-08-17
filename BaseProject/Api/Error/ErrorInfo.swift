//
//  ErrorInfo.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation
enum ErrorDomain: String {
    case Normal = "MWAPIError"
    case Network = "MWNetworkError"
    case NotResponse = "MWAPINotResponse"
}

class ErrorInfo: NSObject {
    var code = -1
    var message = ""
    var title = ""
    var domain = "taxiCrewAPIError"

    convenience init(code: Int, domain: String = ErrorDomain.Normal.rawValue, message: String, title: String?) {
        self.init()
        self.code = code
        self.message = message
        self.title = title ?? ""
        self.domain = domain
    }

    func needShowAlert() -> Bool {
        if self.domain == ErrorDomain.Network.rawValue {
            return false
        }
        return true
    }

    func isErrorFromServer() -> Bool {
        if self.domain == ErrorDomain.Network.rawValue ||
            self.domain == ErrorDomain.NotResponse.rawValue {
            return false
        }
        return true
    }

    func nserror() -> NSError {
        return NSError(domain: self.domain, code: self.code, userInfo: ["message": self.message])
    }

    class func fromError(error: Error?) -> ErrorInfo? {
        guard let nserror = error?.nserror() else {
            return nil
        }
        let info = ErrorInfo()
        info.domain = nserror.domain
        info.code = nserror.code
        info.title = "api.error.title".localized()
        info.message = nserror.domain
        return info
    }

    class func defaultError() -> ErrorInfo {
        if !Utilities.shared.isReachability {
            return ErrorInfo.networkError()
        } else {
            let title = "api.error.title".localized()
            let message = "api.not.response".localized()
            return ErrorInfo(code: -2, domain: ErrorDomain.NotResponse.rawValue, message: message, title: title)
        }
    }

    class func networkError() -> ErrorInfo {
        let title = "api.error.title".localized()
        let message = "network.error.message".localized()
        return ErrorInfo(code: -1, domain: ErrorDomain.Network.rawValue, message: message, title: title)
    }
}
