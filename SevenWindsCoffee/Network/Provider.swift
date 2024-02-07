//
//  Provider.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation
import Moya

enum CoffeeShopAPI {
    case login(login: String, password: String)
    case register(login: String, password: String)
    case getLocations(token: String)
    case getMenu(locationId: Int, token: String)
}

extension CoffeeShopAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://147.78.66.203:3210")!
    }
    
    //nscurl http://147.78.66.203:3210 --verbose --ats-diagnostics
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .getLocations:
            return "/locations"
        case .getMenu(let locationId, _):
            return "/location/\(locationId)/menu"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login, .register:
            return ["Content-type": "application/json"]
        case .getLocations(let token), .getMenu(_, let token):
            return ["Content-type": "application/json", "Authorization": "Bearer \(token)"]
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register:
            return .post
        case .getLocations, .getMenu:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let login, let password), .register(let login, let password):
            return .requestParameters(parameters: ["login": login, "password": password], encoding: JSONEncoding.default)
        case .getLocations, .getMenu:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}


//// Example usage for GET request with Bearer token
//let provider = MoyaProvider<CoffeeShopAPI>()
//let token = "yourBearerToken"
//
//provider.request(.getLocations(token: token)) { result in
//    switch result {
//    case .success(let response):
//        // Handle success
//        let data = response.data
//        let decodedResponse = try? JSONDecoder().decode([Location].self, from: data)
//        print(decodedResponse)
//    case .failure(let error):
//        // Handle error
//        print(error.localizedDescription)
//    }
//}
