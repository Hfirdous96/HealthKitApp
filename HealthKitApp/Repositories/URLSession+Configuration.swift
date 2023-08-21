//
//  URLSession+Configuration.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import Foundation

extension URLSession {
    static var urlSession: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 300
        return URLSession(configuration: config)
    }
}
