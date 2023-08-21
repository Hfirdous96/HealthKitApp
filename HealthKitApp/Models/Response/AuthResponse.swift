//
//  AuthResponse.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import Foundation

struct AuthResponse: Decodable {
    let bearerToken: String
}

extension AuthResponse {
    private enum CodingKeys: String, CodingKey {
        case bearerToken = "jwt"
    }
}
