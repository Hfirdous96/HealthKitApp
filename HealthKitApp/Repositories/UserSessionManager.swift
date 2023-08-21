//
//  UserSessionManager.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import Foundation

final class UserSessionManager {

    static let shared = UserSessionManager()

    let userName = "user1@test.com"
    let password = "Test123!"

    var authResponse: AuthResponse?

    private init() {}

}
