//
//  ApiService.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2017 Dht. All rights reserved.
//

import Foundation
import Alamofire


let baseURL = ""
let postalCodeSearchURl = "http://zip.cgis.biz/xml/zip.php?zn="

enum APIErrorCode: Int {
    case nec_RequestFailed = 400
    case nec_Unauthorized = 401
    case nec_Forbidden = 403
    case nec_NotFound = 404
    case nec_InternalError = 500
    case nec_PostPermissionDisabled = 601
}

typealias NetworkServiceCompletion = (_ response: Any?, _ error: ErrorInfo?) -> ();

/// API base class
class ApiService: NSObject {
    var needIgnoreAfterLogout = true
    let defaultTimeOut: TimeInterval = 60
    var timeout: Timer?
    var isShowAutoLogin = false
    //params
    var params: RequestParams?

    //api url path
    var url: String = ""

    //http request method
    fileprivate var httpmethod: HTTPMethod = .get

    //Default = 1. Mean this request only execute 1 time
    var retryCount: Int = 1

    //Check service is cancelled or not
    var isCancelled: Bool = false

    //Use to cancel request
    var request: Alamofire.Request?

    //param encoding, default JSON
    var paramEncoding: ParameterEncoding = JSONEncoding()
    var completion: NetworkServiceCompletion?
    var defaultHeader: [String: String] = [:]

    convenience init(apiPath: String,
                     method: HTTPMethod = .get,
                     requestParam: RequestParams?,
                     paramEncoding: ParameterEncoding = JSONEncoding(),
                     retryCount: Int = 1) {
        self.init()
        self.paramEncoding = paramEncoding
        self.url = apiPath
        self.httpmethod = method
        self.params = requestParam
        self.retryCount = retryCount //for any request
        
        NotificationCenter.default.addObserver(self, selector: #selector(ApiService.networkDidChange), name: Notification.Name("NetworkStateChange"), object: nil)
    }

    @objc func cancelGetDetail(notify: Notification) {
        if let obj = notify.object as? String {
            if self.url == obj {
                self.cancel()
            }
        }
    }

    @objc func networkDidChange() {
        if !Utilities.shared.isReachability {
            self.cancel()
        }
    }

    //To debug service will be release perfect or not
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func apiBuildinErrorMessage(response: Any?, code: Int) -> ErrorInfo? {
        guard let data = response as? [String: Any] else {
            return nil
        }
        
        let msg = data["MESSAGE"] as? String
        if let msg = msg {
            return ErrorInfo(code: code,
                             domain: ErrorDomain.Normal.rawValue,
                             message: msg,
                             title: "api.error.title".localized())
        } else {
            return nil
        }
    }

    func requestDidFail(_ completion: @escaping NetworkServiceCompletion) {
        var error: ErrorInfo?
        
        if Utilities.shared.isReachability {
            error = ErrorInfo(code: 900,
                              message: "network.error.message".localized(),
                              title: "api.error.title".localized())
        } else {
            error = ErrorInfo(code: 900,
                              message: "api.not.response".localized(),
                              title: "api.error.title".localized())
        }
        self.onFinish(nil, error: error, completion: completion)

    }

    func startTimeoutTimer() {
        self.stopTimeoutTimer()
        self.timeout = Timer.scheduledTimer(timeInterval: defaultTimeOut, target: self, selector: #selector(self.timeoutCallback), userInfo: nil, repeats: false)
    }

    func stopTimeoutTimer() {
        self.timeout?.invalidate()
        self.timeout = nil
    }

    @objc func timeoutCallback() {
        retryCount = 0
        self.cancel()
        self.stopTimeoutTimer()
        if let completion = self.completion {
            self.requestDidFail(completion)
            self.completion = nil
        }
    }

    func doExecute(_ completion: @escaping NetworkServiceCompletion) {
        self.completion = completion
//        self.defaultHeader["X-Token"] = String.deviceudidmd5hash()
//        self.defaultHeader["X-User-Id"] = String.deviceudid()
//        self.defaultHeader["X-Firebase-Token"] = Utils.deviceToken()
        let rqParams = params?.origin()
        self.isCancelled = false
        // count down retry time
        self.retryCount = 0

        //show activity on status bar view
        //Print url for debugs
        print("requesting url ====== \(self.url) params \n \(String(describing: rqParams))")
        //Do not need weakself in completion block because service not owner that block
        DispatchQueue.main.async {
            UIApplication.shared.showActivity(isShow: true)
        }
        self.startTimeoutTimer()
        if let param = params {
            if param.hasBodyDataNeedConstruct() || self.httpmethod == .post {
                //upload multi path
                self.retryCount = 0
                self.uploadMultipathContent(param, completion: completion)
            } else {
                self.doExecuteNormalRequest(rqParams, completion: completion)
            }
        } else {
            self.doExecuteNormalRequest(rqParams, completion: completion)
        }
    }

    func asURLRequest(parameters: [String: Any]?) throws -> URLRequest? {
        if let url = URL(string: self.url) {
            do {
                var urlrequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30)
                urlrequest.allHTTPHeaderFields = self.defaultHeader
                urlrequest.timeoutInterval = defaultTimeOut
                urlrequest.httpMethod = self.httpmethod.rawValue
                return try self.paramEncoding.encode(urlrequest, with: parameters)
            } catch {
                return nil
            }
        }
        return nil
    }

    fileprivate func doExecuteNormalRequest(_ rqParams: [String: Any]?, completion: @escaping NetworkServiceCompletion) {
        do {
            let request = try asURLRequest(parameters: rqParams)
            if let arequest = request {
                Alamofire.request(arequest).responseJSON(completionHandler: { (response) in
                    self.processRequestResponse(response, completion: completion)
                })
            }
        } catch  {
            self.requestDidFail(completion)
        }
    }

    fileprivate func processRequestResponse(_ response: DataResponse<Any>, completion: @escaping NetworkServiceCompletion) {
        self.stopTimeoutTimer()
        // hide network activity
        DispatchQueue.main.async {
            UIApplication.shared.showActivity(isShow: false)
        }
        if let statusCode = response.response?.statusCode {
            if (self.isRequestSuccess(statusCode) == false && self.retryCount > 0) {
                //retry
                self.doExecute(completion)
            } else {
                let buildError = self.apiBuildinErrorMessage(response: response.result.value, code: statusCode)
                let error = buildError != nil ? buildError  : self.parseErrorFromOrigniResponseValue(response.result.value, statusCode: statusCode)
                self.onFinish(response.result.value ?? response.data,
                              statusCode: statusCode,
                              error: error,
                              completion: completion)
            }

        } else {
            if (retryCount > 0 ) {
                self.doExecute(completion)
            } else {
                self.requestDidFail(completion)
            }
        }
    }

    func buildMultpathDataFromDict(_ multipartFormData: MultipartFormData, parameters: [String: Any]) {
        for (key, value) in parameters {
            if let array = value as? [[String : Any]] {
                for dict in array {
                    for (key2, value2) in dict {
                        let newKey = key + "[][\(key2)]"
                        var content = ""
                        if let newvalue = value2 as? String {
                            content = newvalue
                        } else {
                            content = String(describing: value2)
                        }
                        if let data = content.data(using: String.Encoding.utf8) {
                            multipartFormData.append(data, withName: newKey)
                        }
                    }
                }
            }  else {
                if let dictValues = value as? [String : AnyObject] {
                    self.buildMultpathDataFromDict(multipartFormData, parameters: dictValues)
                } else {
                    if let str = value as? String {
                        if let data = str.data(using: String.Encoding.utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    } else {
                        let str = String(describing: value)
                        if let data = str.data(using: String.Encoding.utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
            }
        }
    }


    fileprivate func uploadMultipathContent(_ params: RequestParams, completion: @escaping NetworkServiceCompletion) {
        var header = self.defaultHeader
        header["Content-Type"] =  "multipart/form-data"
        header["Cache-Control"] = "no-cache"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for bodyData in params.bodyDatas {
                if let content = bodyData.data {
                    if let fileData = bodyData as? RequestFileBodyData {
                        multipartFormData.append(content, withName: fileData.name ?? "", fileName: fileData.filename , mimeType: fileData.mineType)
                    } else {
                        multipartFormData.append(content, withName: bodyData.name ?? "")
                    }
                }
            }
            self.buildMultpathDataFromDict(multipartFormData, parameters: params.origin())
        }, to: self.url, method: self.httpmethod, headers: header) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.validate()
                self.request =  upload.responseJSON { response in
                    self.processRequestResponse(response, completion: completion)
                }
            case .failure( _):
                self.requestDidFail(completion)
            }
        }
    }

    func autoRenewAccessTokenIfNeed(_ completion : @escaping (_ success: Bool, _ hasLoggedBefore: Bool)->()) {
    }

    func errorMessageWithStatus(_ status: Int) -> String? {
        return nil
    }

    func errorWithStatus(_ statusCode: Int) -> ErrorInfo? {
        var errMsg: String?
        switch statusCode {
        case APIErrorCode.nec_Forbidden.rawValue:
            errMsg = "Forbidden - you are not login user"
        case APIErrorCode.nec_InternalError.rawValue:
            errMsg = "Internal Server Error - there are errors on server"
        case APIErrorCode.nec_NotFound.rawValue:
            errMsg = "Not Found - server doesn't have resource"
        case APIErrorCode.nec_RequestFailed.rawValue:
            errMsg = "Forbidden - you are not login user"
        case APIErrorCode.nec_Unauthorized.rawValue:
            errMsg = "The request token is invalid"
        default:
            break
        }

        if errMsg == nil {
            errMsg = self.errorMessageWithStatus(statusCode)
        }
        return errMsg != nil ? ErrorInfo(code: statusCode, message: errMsg!, title: nil) : nil
    }

    func parseErrorFromOrigniResponseValue(_ response: Any?, statusCode: Int) -> ErrorInfo? {
        //parse error
        var errInfo: ErrorInfo?
        if errInfo == nil {
            if let responseDict = response as? NSDictionary {
               // Logger.log("request api :\(self.url)\nresponse:\(responseDict)")
                if let errMsg = responseDict["message"] as? String {
                    errInfo = ErrorInfo()
                    errInfo?.code = statusCode

                    errInfo?.message = errMsg
                }
            }
        }
        if errInfo == nil {
            errInfo = self.errorWithStatus(statusCode)
        }
        return  errInfo
    }

    /**/
    func onFinish(_ response: Any?, statusCode: Int = 0, error: ErrorInfo?, completion: NetworkServiceCompletion?) {
        DispatchQueue.main.async(execute: {
            completion?(response, error)
        })
    }

    func isRequestSuccess(_ statusCode: Int) -> Bool {
        return (statusCode >= 200 && statusCode < 300)
    }

    func cancel() {
        self.request?.cancel()
        isCancelled = true
    }
}
