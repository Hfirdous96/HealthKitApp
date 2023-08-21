//
//  StoreStepDataRequest.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import Foundation

struct StoreStepDataRequest: Encodable {
    let userName: String
    let stepsDate: String
    let stepsDateTime: String
    let stepsCount: Int
    let stepsTotal: Int

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userName, forKey: .userName)
        try container.encode(stepsDate, forKey: .stepsDate)
        try container.encode(stepsDateTime, forKey: .stepsDateTime)
        try container.encode(stepsCount, forKey: .stepsCount)
        try container.encode(stepsTotal, forKey: .stepsTotal)
    }
}

extension StoreStepDataRequest {
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case stepsDate = "steps_date"
        case stepsDateTime = "steps_datetime"
        case stepsCount = "steps_count"
        case stepsTotal = "steps_total_by_day"
    }
}
