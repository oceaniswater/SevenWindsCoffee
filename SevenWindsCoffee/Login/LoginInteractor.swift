//
//  LoginInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation

protocol LoginInteractorPtotocol {
    func loginUser(login: String, password: String)
}

protocol LoginInteractorOutputProtocol: AnyObject {
    func loginSuccess(token: String, tokenLifetime: TimeInterval)
    func loginError(message: String)
}
