//
//  TableViewModel.swift
//  BaseProject
//
//  Created by MTQ on 8/1/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation

class TableViewModel {
    var page = 0
    var pageSize = 20
    var students: [Student] = []
    
    func getWeathers(isLoadmore: Bool, completion: @escaping (() -> Void)) {
        if isLoadmore {
            page += 1
        } else {
            page = 0
        }
        let encoding = Encoding.forMethod(method: .get)
        let path = Path.getWeathers.path
        let params = RequestParams()
        params.setValue(pageSize, forKey: "page-size")
        params.setValue(page, forKey: "page")
        let service = GetWeatherService(apiPath: path,
                                        method: .get,
                                        requestParam: nil,
                                        paramEncoding: encoding,
                                        retryCount: 1)
        service.doExecute { [weak self] (response, error) in
            guard let `self` = self else { return }
            if let response = response as? [Student] {
                if !isLoadmore {
                    self.students = response
                } else {
                    response.forEach { obj in
                        if !self.isExistsObject(object: obj, listObject: self.students) {
                            self.students.append(contentsOf: response)
                        }
                    }
                }
            }
            completion()
        }
    }
    
    func isExistsObject(object: Student, listObject: [Student]) -> Bool {
        let results = listObject.filter { $0.id == object.id }
        return results.count > 0
    }
}
