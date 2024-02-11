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
    func registrateUser(login: String, password: String)
}

protocol RegistrationInteractorOutputProtocol: AnyObject {
    func registrationSuccess(token: String, tokenLifetime: TimeInterval)
    func registrationError(message: String)
}

class RegistrationInteractor: RegistrationInteractorPtotocol {
    var presenter: RegistrationPresenterProtocol?
    
    var output: RegistrationInteractorOutputProtocol!
    
    func registrateUser(login: String, password: String) {
        NetworkManager.shared.registerUser(login: login, password: password) { [weak self] result in
            switch result {
            case .success(let decodedResponse):
                // Handle success
                let token = decodedResponse.token
                self?.presenter?.registrationSuccess(token: token, tokenLifetime: decodedResponse.tokenLifetime)
            case .failure(let networkError):
                switch networkError {
                case .unauthorised:
                    self?.presenter?.registrationError(message: networkError.localizedDescription)
                    break
                case .invalidStatusCode(_):
                    self?.presenter?.registrationError(message: networkError.localizedDescription)
                    break
                case .decodingError(_):
                    self?.presenter?.registrationError(message: networkError.localizedDescription)
                    break
                case .moyaError(_):
                    self?.presenter?.registrationError(message: networkError.localizedDescription)
                    break
                case .userExist:
                    self?.presenter?.registrationError(message: networkError.localizedDescription)
                    break
                }
            }
        }
    }
}
