//
//  StepData.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import Foundation

struct StepData {
    var date: Date
    var count: Int
}

extension StepData {
    var timeInHour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: date)
    }

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }
}
