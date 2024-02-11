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
    
    func fetchCoffeeShops()
    func fetchSuccess(shops: CoffeeShopsEntity)
    func fetchError(message: String)
    func unauthorisedUser()
    
    func tapOnItem(id: Int)
    func tapOnMapButton()
    
    var shops: CoffeeShopsEntity { get set }
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

class CoffeShopsPresenter: CoffeeShopsPresenterProtocol, CoffeeShopsInteractorOutputProtocol {
    var router: CoffeeShopsRouterProtocol?
    var interactor: CoffeeShopsInteractorPtotocol?
    var view: CoffeeShopsViewProtocol?
    
    var shops: CoffeeShopsEntity = []
    
    init() {
        fetchCoffeeShops()
    }
    
    func fetchCoffeeShops() {
        guard let token = KeychainHelper.shared.getCredentials() else { return }
        interactor?.fetchData(token: token)
    }
    
    func fetchSuccess(shops: [CoffeeShopsEntityElement]) {
        self.shops = shops
        view?.fetchShopSuccess()
    }
    
    func tapOnItem(id: Int) {
        router?.navigateToMenu(id: id)
    }
    
    func tapOnMapButton() {
        router?.navigateToMap()
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
        return self.shops.count
    }
}
