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
    
    var items: OrderEntity { get set }
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

class OrderPresenter: OrderPresenterProtocol, OrderInteractorOutputProtocol {
    
    var router: OrderRouterProtocol?
    var interactor: OrderInteractorPtotocol?
    var view: OrderViewProtocol?
    
    var items: OrderEntity = [OrderEntityElement(item: MenuItemsEntityElement(id: 1, name: "Americano", imageURL: "", price: 200), count: 1), OrderEntityElement(item: MenuItemsEntityElement(id: 1, name: "Americano", imageURL: "", price: 200), count: 1), OrderEntityElement(item: MenuItemsEntityElement(id: 1, name: "Americano", imageURL: "", price: 200), count: 1)]
    
    init() {
        fetchCoffeeShops()
    }
    
    
    func fetchCoffeeShops() {
        guard let token = KeychainHelper.shared.getCredentials() else { return }
        interactor?.fetchData(token: token)
    }
    
    func fetchSuccess(items: OrderEntity) {
        self.items = items
        view?.fetchShopSuccess()
    }
    
    func fetchError(message: String) {
        view?.showFetchError(message: message)
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.items.count
    }
}


