//
//  TableViewModel.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation

class TableViewModel {
    func getWeathers(completion: @escaping NetworkServiceCompletion) {
        let encoding = Encoding.forMethod(method: .get)
        let service = GetWeatherService(apiPath: Path.getWeathers.path,
                                        method: .get,
                                        requestParam: nil,
                                        paramEncoding: encoding,
                                        retryCount: 1)
        service.doExecute(completion)
    }
}
