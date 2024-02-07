//
//  LoginView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation

protocol LoginViewProtocol: AnyObject {
    func showLoginSuccess(token: String, tokenLifetime: TimeInterval)
    func showLoginError(message: String)
}
