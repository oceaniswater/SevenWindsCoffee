//
//  LoginPresenter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation

protocol LoginPresenterProtocol {
    var router: LoginRouterProtocol? {get set}
    var interactor: LoginInteractorPtotocol? {get set}
    var view: LoginViewProtocol? {get set}
    
    func loginButtonTapped(login: String, password: String)
    func loginSuccess(token: String, tokenLifetime: TimeInterval)
    func loginError(message: String)
}

class LoginPresenter: LoginPresenterProtocol, LoginInteractorOutputProtocol {
    var router: LoginRouterProtocol?
    var interactor: LoginInteractorPtotocol?
    var view: LoginViewProtocol?
    
    
    func loginButtonTapped(login: String, password: String) {
        interactor?.loginUser(login: login, password: password)
    }
    
    func loginSuccess(token: String, tokenLifetime: TimeInterval) {
        KeychainHelper.shared.saveToken(token: token)
        view?.showLoginSuccess()
        router?.navigateToCofeeShops()
    }
    
    func loginError(message: String) {
        view?.showLoginError(message: message)
    }
}
