//
//  HealthKitService.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import Foundation
import HealthKit

protocol HealthKitService {
    func changeAuthorizationStatus() -> Bool
    func requestAuthorization(onCompletion: @escaping (Bool, Error?) -> Void)
    func getTodayStepCount(onCompletion: @escaping (Double) -> Void)
    func getStepsByHourToday(onCompletion: @escaping ([StepData]) -> Void)
    func getSteps(by days: Int, onCompletion: @escaping ([StepData]) -> Void)
}

struct RealHealthKitService: HealthKitService {

    private var healthStore = HKHealthStore()

    func requestAuthorization(onCompletion: @escaping (Bool, Error?) -> Void) {
        if HKHealthStore.isHealthDataAvailable(), let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) {
            healthStore.requestAuthorization(toShare: [stepCount], read: [stepCount], completion: onCompletion)
        }
    }

    func changeAuthorizationStatus() -> Bool {
        guard let stepQtyType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return false}
        let status = healthStore.authorizationStatus(for: stepQtyType)
        return status == .sharingAuthorized
    }
}

extension RealHealthKitService {

    func getTodayStepCount(onCompletion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                onCompletion(0.0)
                return
            }
            onCompletion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }

    private func getSteps(from startDate: Date, to endDate: Date, interval: DateComponents, onCompletion: @escaping ([StepData]) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            onCompletion([])
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                print("Error fetching step data: \(error.localizedDescription)")
                onCompletion([])
                return
            }
            guard let results = results else {
                onCompletion([])
                return
            }

            var data: [StepData] = []
            results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let count: Double = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
                data.append(StepData(date: statistics.startDate, count: Int(count)))
            }

            onCompletion(data)
        }
        healthStore.execute(query)
    }

    func getStepsByHourToday(onCompletion: @escaping ([StepData]) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        getSteps(from: startOfDay, to: now, interval: DateComponents(hour: 1), onCompletion: onCompletion)
    }

    func getSteps(by days: Int, onCompletion: @escaping ([StepData]) -> Void) {
        let now = Date()
        let daysBeforeNow = Calendar.current.date(byAdding: .day, value: -1 * days, to: now)!
        getSteps(from: daysBeforeNow, to: now, interval: DateComponents(day: 1), onCompletion: onCompletion)
    }
}
