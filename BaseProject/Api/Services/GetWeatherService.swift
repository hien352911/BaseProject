//
//  GetWeatherService.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation

class GetWeatherService: ApiService {
    override func onFinish(_ response: Any?, statusCode: Int, error: ErrorInfo?, completion: NetworkServiceCompletion?) {
        var summarys: [String] = []
        if let response = response as? [String: Any] {
            if let hourly = response["hourly"] as? [String: Any] {
                if let data = hourly["data"] as? [[String: Any]] {
                    for dict in data {
                        if let summary = dict["summary"] as? String {
                            summarys.append(summary)
                        }
                    }
                }
            }
        }
        super.onFinish(summarys, statusCode: statusCode, error: error, completion: completion)
    }
}
