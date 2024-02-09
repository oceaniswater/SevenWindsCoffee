//
//  RegistrationInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import Foundation
import Moya

protocol RegistrationInteractorPtotocol: AnyInteractorProtocol {
    var presenter: RegistrationPresenterProtocol? {get set}
    func loginUser(login: String, password: String)
}

protocol RegistrationInteractorOutputProtocol: AnyObject {
    func loginSuccess(token: String, tokenLifetime: TimeInterval)
    func loginError(message: String)
}

class RegistrationInteractor: RegistrationInteractorPtotocol {
    var presenter: RegistrationPresenterProtocol?
    
    var output: RegistrationInteractorOutputProtocol!
    
    func loginUser(login: String, password: String) {

        let provider = MoyaProvider<CoffeeShopAPI>()
        
        provider.request(.login(login: login, password: password)) { [weak self] result in
            switch result {
            case .success(let response):
                // Handle success
                let data = response.data
                let decodedResponse = try? JSONDecoder().decode(LoginEntity.self, from: data)
                guard let token = decodedResponse?.token else { return }
                self?.presenter?.loginSuccess(token: token, tokenLifetime: decodedResponse?.tokenLifetime ?? TimeInterval(123))
            case .failure(let error):
                // Handle error
                self?.presenter?.loginError(message: error.localizedDescription)
            }
        }
    }
}

