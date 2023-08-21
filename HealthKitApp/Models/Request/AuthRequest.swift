//
//  AuthRequest.swift
//  HealthKitApp
//
//  Created by Firdous on 20/08/23.
//

import Foundation

struct AuthRequest: Encodable {
    let userName: String
    let password: String

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userName, forKey: .userName)
        try container.encode(password, forKey: .password)
    }
}

extension AuthRequest {
    private enum CodingKeys: String, CodingKey {
        case userName = "identifier"
        case password
    }
}
