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
    
    func loginButtonTapped(login: String, password: String)
    func loginSuccess(token: String, tokenLifetime: TimeInterval)
    func loginError(message: String)
}

class RegistrationPresenter: RegistrationPresenterProtocol, RegistrationInteractorOutputProtocol {
    var router: RegistrationRouterProtocol?
    var interactor: RegistrationInteractorPtotocol?
    var view: RegistrationViewProtocol?
    
    
    func loginButtonTapped(login: String, password: String) {
        interactor?.loginUser(login: login, password: password)
    }
    
    func loginSuccess(token: String, tokenLifetime: TimeInterval) {
        view?.registerSuccess()
        router?.navigateToLogin()
    }
    
    func loginError(message: String) {
        view?.showLoginError(message: message)
    }
}

