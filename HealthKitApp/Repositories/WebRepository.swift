//
//  WebRepository.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import Foundation
import Combine

enum NetworkError: Swift.Error {
    case unauthorized
    case noResponse
    case invalidResponse
    case requestFailed
}

protocol WebRepository {
    func call<Value: Decodable>(request: URLRequest, publicApi: Bool) async throws -> Value
}

class RealWebRepository: WebRepository {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func call<Value: Decodable>(request: URLRequest, publicApi: Bool) async throws -> Value {
        try await callApi(request: request, publicApi: publicApi)
    }

    private func callApi<Value: Decodable>(request: URLRequest, publicApi: Bool) async throws -> Value {
        do {
            let request = signedRequest(request, publicApi: publicApi)
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }

            return try decoder.decode(Value.self, from: data)

        } catch {
            throw NetworkError.requestFailed
        }

    }

    private func signedRequest(_ request: URLRequest, publicApi: Bool) -> URLRequest {
        var urlRequest = request
        if publicApi == false, let token = UserSessionManager.shared.authResponse?.bearerToken {
            let bToken = "Bearer \(token)"
            urlRequest.addValue(bToken, forHTTPHeaderField: "Authorization")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        // Add Any Custom logic
        return decoder
    }()
}


