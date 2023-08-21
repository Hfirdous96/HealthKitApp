//
//  HealthKitAppApp.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import SwiftUI

@main
struct HealthKitAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: Self.bootstrap())
        }
    }
}

extension HealthKitAppApp {
    static func bootstrap() -> ContentView.ViewModel {
        let webRepository = RealWebRepository(session: .urlSession)
        let userService = RealUserService(webRepository: webRepository)
        let healthKitService = RealHealthKitService()
        return .init(healthKitService: healthKitService, userService: userService)
    }
}
