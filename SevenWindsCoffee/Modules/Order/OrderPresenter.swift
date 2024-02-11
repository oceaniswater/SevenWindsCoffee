//
//  OrderPresenter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import Foundation

protocol OrderPresenterProtocol {
    var router: OrderRouterProtocol? {get set}
    var interactor: OrderInteractorPtotocol? {get set}
    var view: OrderViewProtocol? {get set}
    
    func fetchCoffeeShops()
    func fetchSuccess(items: OrderEntity)
    func fetchError(message: String)
    func unauthorisedUser()
    
    var items: OrderEntity { get set }
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

class OrderPresenter: OrderPresenterProtocol, OrderInteractorOutputProtocol {
    
    var router: OrderRouterProtocol?
    var interactor: OrderInteractorPtotocol?
    var view: OrderViewProtocol?
    
    var items: OrderEntity
    
    init(items: OrderEntity) {
        self.items = items
    }
    
    func fetchCoffeeShops() {
        guard let token = KeychainHelper.shared.getCredentials() else { return }
        interactor?.fetchData(token: token)
    }
    
    func fetchSuccess(items: OrderEntity) {
    }
    
    func fetchError(message: String) {
        view?.showFetchError(message: message)
    }
    
    func unauthorisedUser() {
        view?.unauthorisedUser()
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.items.count
    }
}


