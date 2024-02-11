//
//  RegistrationPresenter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import Foundation

protocol RegistrationPresenterProtocol {
    var router: RegistrationRouterProtocol? {get set}
    var interactor: RegistrationInteractorPtotocol? {get set}
    var view: RegistrationViewProtocol? {get set}
    
    func registerButtonTapped(login: String, password: String)
    func registrationSuccess(token: String, tokenLifetime: TimeInterval)
    func registrationError(message: String)
    func validateFields(email: String, password: String, password2: String) -> Bool
}

class RegistrationPresenter: RegistrationPresenterProtocol, RegistrationInteractorOutputProtocol {
    var router: RegistrationRouterProtocol?
    var interactor: RegistrationInteractorPtotocol?
    var view: RegistrationViewProtocol?
    
    
    func registerButtonTapped(login: String, password: String) {
        interactor?.registrateUser(login: login, password: password)
    }
    
    func registrationSuccess(token: String, tokenLifetime: TimeInterval) {
        view?.registerSuccess()
        router?.navigateToLogin()
    }
    
    func registrationError(message: String) {
        view?.showRegistrationError(message: message)
    }
    
    func validateFields(email: String, password: String, password2: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            view?.displayValidationError(.emptyFieldsError)
            return false
        }
        
        guard password == password2 else {
            view?.displayValidationError(.passwordNotMaching)
            return false}
        return true
    }
    
}
