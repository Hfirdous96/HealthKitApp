//
//  StoreStepsDataResponse.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import Foundation

struct StoreStepsDataResponse: Decodable {
    let id: Int
    let userName: String
    let stepsDate: String
    let stepsDateTime: String
    let stepsCount: Int
    let stepsTotal: Int
}

extension StoreStepsDataResponse {

    var formatedStepDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: stepsDate) ?? Date()
    }

    var formattedStepsDateTime: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: stepsDateTime) ?? Date()
    }
}

extension StoreStepsDataResponse {
    private enum CodingKeys: String, CodingKey {
        case id
        case userName = "username"
        case stepsDate = "steps_date"
        case stepsDateTime = "steps_datetime"
        case stepsCount = "steps_count"
        case stepsTotal = "steps_total_by_day"
    }
}

//{
//    "id": 302,
//    "username": "user1",
//    "steps_date": "2023-08-20",
//    "steps_datetime": "2023-08-20T22:58:36.979Z",
//    "steps_count": 10,
//    "steps_total": null,
//    "created_datetime": null,
//    "created_at": "2023-08-20T18:06:51.804Z",
//    "updated_at": "2023-08-20T18:06:51.804Z",
//    "steps_total_by_day": 10
//}
