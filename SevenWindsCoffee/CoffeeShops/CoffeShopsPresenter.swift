//
//  CoffeeShopsPresenter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation

protocol CoffeeShopsPresenterProtocol {
    var router: CoffeeShopsRouterProtocol? {get set}
    var interactor: CoffeeShopsInteractorPtotocol? {get set}
    var view: CoffeeShopsViewProtocol? {get set}
    
    func loginButtonTapped(login: String, password: String)
    func loginSuccess(token: String, tokenLifetime: TimeInterval)
    func loginError(message: String)
    
    var shops: [CoffeeShopsEntityElement] { get set }
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

class CoffeShopsPresenter: CoffeeShopsPresenterProtocol, CoffeeShopsInteractorOutputProtocol {
    var router: CoffeeShopsRouterProtocol?
    var interactor: CoffeeShopsInteractorPtotocol?
    var view: CoffeeShopsViewProtocol?
    
    var shops: [CoffeeShopsEntityElement] = [CoffeeShopsEntityElement(id: 1, name: "Mac cafee", point: Point(latitude: "212312323", longitude: "1312312424")), CoffeeShopsEntityElement(id: 1, name: "Mac cafee", point: Point(latitude: "212312323", longitude: "1312312424")), CoffeeShopsEntityElement(id: 1, name: "Mac cafee", point: Point(latitude: "212312323", longitude: "1312312424")), CoffeeShopsEntityElement(id: 1, name: "Mac cafee", point: Point(latitude: "212312323", longitude: "1312312424"))]
    
    
    func loginButtonTapped(login: String, password: String) {
        interactor?.loginUser(login: login, password: password)
    }
    
    func loginSuccess(token: String, tokenLifetime: TimeInterval) {
        view?.showLoginSuccess(token: token, tokenLifetime: tokenLifetime)
    }
    
    func loginError(message: String) {
        view?.showLoginError(message: message)
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.shops.count
    }
}

