//
//  NetworkManager.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 11/02/2024.
//

import Moya
import Foundation

enum NetworkError: Error {
    case invalidStatusCode(Int)
    case decodingError(Error)
    case moyaError(MoyaError)
    case unauthorised

    var localizedDescription: String {
        switch self {
        case .invalidStatusCode(let code):
            return "Invalid HTTP status code: \(code)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .moyaError(let error):
            return "Moya error: \(error.localizedDescription)"
        case .unauthorised:
            return "Неправильный логин или пароль."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<CoffeeShopAPI>()

    private init() {}

    func registerUser(login: String, password: String, completion: @escaping (Result<LoginEntity, Error>) -> Void) {
        provider.request(.register(login: login, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginEntity.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(login: String, password: String, completion: @escaping (Result<LoginEntity, NetworkError>) -> Void) {
        provider.request(.login(login: login, password: password)) { result in
            switch result {
            case .success(let response):
                
                guard (200...299).contains(response.statusCode) else {
                    // Handle invalid HTTP status code
                    if response.statusCode == 401 {
                        let networkError = NetworkError.unauthorised
                        completion(.failure(networkError))
                    } else {
                        let networkError = NetworkError.invalidStatusCode(response.statusCode)
                        completion(.failure(networkError))
                    }
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginEntity.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                let networkError = NetworkError.moyaError(error)
                completion(.failure(networkError))
            }
        }
    }

}
