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
    case userExist
    
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
        case .userExist:
            return "Пользователь с таким email уже существует."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<CoffeeShopAPI>()
    
    private init() {}
    
    func registerUser(login: String, password: String, completion: @escaping (Result<RegistrationEntity, NetworkError>) -> Void) {
        provider.request(.register(login: login, password: password)) { result in
            switch result {
            case .success(let response):
                guard (200...299).contains(response.statusCode) else {
                    // Handle invalid HTTP status code
                    if response.statusCode == 401 {
                        let networkError = NetworkError.unauthorised
                        completion(.failure(networkError))
                    } else if response.statusCode == 406{
                        let networkError = NetworkError.userExist
                        completion(.failure(networkError))
                    } else {
                        let networkError = NetworkError.invalidStatusCode(response.statusCode)
                        completion(.failure(networkError))
                    }
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(RegistrationEntity.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    let networkError = NetworkError.decodingError(error)
                    completion(.failure(networkError))
                }
            case .failure(let error):
                let networkError = NetworkError.moyaError(error)
                completion(.failure(networkError))
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
    
    func fetchCoffeeShops(token: String, completion: @escaping (Result<CoffeeShopsEntity, NetworkError>) -> Void) {
        provider.request(.getLocations(token: token)) { result in
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
                    let decodedResponse = try JSONDecoder().decode(CoffeeShopsEntity.self, from: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    let networkError = NetworkError.decodingError(error)
                    completion(.failure(networkError))
                }
            case .failure(let error):
                let networkError = NetworkError.moyaError(error)
                completion(.failure(networkError))
            }
        }
    }
    
    func fetchMenuItems(token: String, locationId: Int, completion: @escaping (Result<MenuItemsEntity, NetworkError>) -> Void) {
        provider.request(.getMenu(locationId: locationId, token: token)) { result in
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
                    let decodedResponse = try JSONDecoder().decode(MenuItemsEntity.self, from: response.data)
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
