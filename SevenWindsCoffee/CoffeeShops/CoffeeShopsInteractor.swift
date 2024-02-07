//
//  CoffeeShopsInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation
import Moya

protocol CoffeeShopsInteractorPtotocol: AnyInteractorProtocol {
    var presenter: CoffeeShopsPresenterProtocol? {get set}
    func loginUser(login: String, password: String)
}

protocol CoffeeShopsInteractorOutputProtocol: AnyObject {
    func loginSuccess(token: String, tokenLifetime: TimeInterval)
    func loginError(message: String)
}

class CoffeeShopsInteractor: CoffeeShopsInteractorPtotocol {
    var presenter: CoffeeShopsPresenterProtocol?
    
    var output: CoffeeShopsInteractorOutputProtocol!
    
    func loginUser(login: String, password: String) {

        let provider = MoyaProvider<CoffeeShopAPI>()
        
        provider.request(.login(login: login, password: password)) { [weak self] result in
            switch result {
            case .success(let response):
                // Handle success
                let data = response.data
                let decodedResponse = try? JSONDecoder().decode(LoginEntity.self, from: data)
                self?.presenter?.loginSuccess(token: decodedResponse?.token ?? "", tokenLifetime: decodedResponse?.tokenLifetime ?? TimeInterval(123))
            case .failure(let error):
                // Handle error
                self?.presenter?.loginError(message: error.localizedDescription)
            }
        }
    }
}
