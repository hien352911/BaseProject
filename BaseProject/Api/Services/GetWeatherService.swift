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
        if let error = error {
            print(error.description)
        }
        var students: [Student] = []
        if let response = response as? [String: Any] {
            if let data = response["data"] as? [[String: Any]] {
                for dict in data {
                    if let student = Student(JSON: dict) {
                        students.append(student)
                    }
                }
            }
        }
        super.onFinish(students, statusCode: statusCode, error: error, completion: completion)
    }
}
