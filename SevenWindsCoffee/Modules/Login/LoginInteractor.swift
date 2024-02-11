//
//  LoginInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation
import Moya

protocol AnyInteractorProtocol {
    
}

protocol LoginInteractorPtotocol: AnyInteractorProtocol {
    var presenter: LoginPresenterProtocol? {get set}
    func loginUser(login: String, password: String)
}

protocol LoginInteractorOutputProtocol: AnyObject {
    func loginSuccess(token: String, tokenLifetime: TimeInterval)
    func loginError(message: String)
}

class LoginInteractor: LoginInteractorPtotocol {
    var presenter: LoginPresenterProtocol?
    
    var output: LoginInteractorOutputProtocol!
    
    func loginUser(login: String, password: String) {
        NetworkManager.shared.loginUser(login: login, password: password) { [weak self] result in
            switch result {
            case .success(let decodedResponse):
                // Handle success
                let token = decodedResponse.token
                self?.presenter?.loginSuccess(token: token, tokenLifetime: decodedResponse.tokenLifetime)
            case .failure(let networkError):
                switch networkError {
                case .unauthorised:
                    self?.presenter?.loginError(message: networkError.localizedDescription)
                    break
                case .invalidStatusCode(_):
                    self?.presenter?.loginError(message: networkError.localizedDescription)
                    break
                case .decodingError(_):
                    self?.presenter?.loginError(message: networkError.localizedDescription)
                    break
                case .moyaError(_):
                    self?.presenter?.loginError(message: networkError.localizedDescription)
                    break
                case .userExist:
                    self?.presenter?.loginError(message: networkError.localizedDescription)
                    break
                }
            }
        }
    }
}
