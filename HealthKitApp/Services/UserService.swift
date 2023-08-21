//
//  UserService.swift
//  HealthKitApp
//
//  Created by Firdous on 19/08/23.
//

import Foundation

protocol UserService {
    func fetchAuthToken(_ authRequest: AuthRequest, onCompletion: @escaping (AuthResponse?) -> Void)
    func fetchStepsCount(for days: Int, onCompletion: @escaping ([StoreStepsDataResponse]) -> Void)
    func storeStepsCount(data: StoreStepDataRequest, onCompletion: @escaping (StoreStepsDataResponse?) -> Void)
}

struct RealUserService: UserService {

    let webRepository: WebRepository

    init(webRepository: WebRepository) {
        self.webRepository = webRepository
    }

    func fetchAuthToken(_ authRequest: AuthRequest, onCompletion: @escaping (AuthResponse?) -> Void) {
        Task {
            let url = URL(string: "https://testapi.mindware.us/auth/local")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let jsonData = try JSONEncoder().encode(authRequest)
            request.httpBody = jsonData
            let authResponse = try? await webRepository.call(request: request, publicApi: true) as AuthResponse
            onCompletion(authResponse)
        }
    }

    func fetchStepsCount(for days: Int, onCompletion: @escaping ([StoreStepsDataResponse]) -> Void) {
        Task {
            let url = URL(string: "https://testapi.mindware.us/steps")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let response = try? await webRepository.call(request: request, publicApi: false) as [StoreStepsDataResponse]
            if let result = response {
                // filter for last N days
                let now = Date()
                let daysBeforeNow = Calendar.current.date(byAdding: .day, value: -1 * days, to: now)!
                let filtteredData = result.filter { item in
                    return item.formatedStepDate >= daysBeforeNow
                }
                onCompletion(filtteredData)
            } else {
                onCompletion([])
            }
        }
    }

    func storeStepsCount(data: StoreStepDataRequest, onCompletion: @escaping (StoreStepsDataResponse?) -> Void) {
        Task {
            let url = URL(string: "https://testapi.mindware.us/steps")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
            let response = try? await webRepository.call(request: request, publicApi: false) as StoreStepsDataResponse
            onCompletion(response)
        }
    }
}
