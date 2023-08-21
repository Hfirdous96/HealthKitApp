//
//  ContentViewModel.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var isAuthorized = false
        @Published var userStepCount = ""
        @Published var stepsProgress = 0.0
        @Published var todayCharData: [BarChartData] = []
        @Published var historyChartData: [BarChartData] = []

        var lastStepsCount = 0
        let stepsGoal = 10000

        let healthKitService: HealthKitService
        let userService: UserService

        init(healthKitService: HealthKitService, userService: UserService) {
            self.healthKitService = healthKitService
            self.userService = userService
            setupRefreshSteps()
        }

        func setupRefreshSteps() {
            Timer.scheduledTimer(withTimeInterval: 5 * 60, repeats: true) { time in
                debugPrint("Step Count Refreshed.")
                self.fetchTodayStepCount()
            }
        }

        func healthAuthorizationRequest() {
            healthKitService.requestAuthorization { status, error in
                DispatchQueue.main.async {
                    if status {
                        self.isAuthorized = self.healthKitService.changeAuthorizationStatus()
                        self.fetchTodayStepCount()
                    } else if let _ = error {
                        self.isAuthorized = false
                    }
                }
            }
        }

        func fetchTodayStepCount() {
            if isAuthorized == false {
                return
            }

            // Get Today's Step Count
            healthKitService.getTodayStepCount { count in
                let result = Int(count)

                DispatchQueue.main.async {
                    self.stepsProgress = count / Double(self.stepsGoal)
                    self.userStepCount = String(format: "%d", result)
                }

                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
                    let stepsDiff = abs(self.lastStepsCount - result)
                    self.storeStepCount(stepsCount: stepsDiff, totalSteps: result )
                    self.lastStepsCount = result
                }
            }

            // Hours Step Count
            healthKitService.getStepsByHourToday { steps in
                DispatchQueue.main.async {
                    self.todayCharData = steps.map { BarChartData(xKey: "time", xValue: $0.timeInHour, yKey: "steps", yValue: $0.count)}
                }
            }
        }

        func getHistoryStepCount(for days: Int) {
            userService.fetchStepsCount(for: days) { items in
                DispatchQueue.main.async {
                    let steps = items.map({StepData(date: $0.formatedStepDate, count: $0.stepsTotal)})
                    self.historyChartData = steps.map { BarChartData(xKey: "time", xValue: $0.day, yKey: "steps", yValue: $0.count)}
                }
            }
        }

        func storeStepCount(stepsCount: Int, totalSteps: Int) {
            guard let _ = UserSessionManager.shared.authResponse?.bearerToken else {
                return
            }

            let userName = UserSessionManager.shared.userName
            let stepsDate = Date().formattedStepsDate
            let stepsDatetime = Date().formattedStepsDateTime

            let dataRequest = StoreStepDataRequest(userName: userName,
                                                   stepsDate: stepsDate,
                                                   stepsDateTime: stepsDatetime,
                                                   stepsCount: stepsCount,
                                                   stepsTotal: totalSteps)

            userService.storeStepsCount(data: dataRequest) { response in
                if let response = response {
                    debugPrint("Steps Count Saved")
                } else {
                    debugPrint("Steps Count Failed to save !!")
                }
            }
        }
    }
}

extension ContentView.ViewModel {

    func getAuthToken() {
        let userName = UserSessionManager.shared.userName
        let pwd = UserSessionManager.shared.password
        let userData = AuthRequest(userName: userName, password: pwd)
        userService.fetchAuthToken(userData) { response in
            UserSessionManager.shared.authResponse = response
        }
    }
}
