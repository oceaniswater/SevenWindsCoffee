//
//  MapPresenter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 10/02/2024.
//

import Foundation

protocol MapPresenterProtocol {
    var router: MapRouterProtocol? {get set}
    var interactor: MapInteractorPtotocol? {get set}
    var view: MapViewProtocol? {get set}
    
    func fetchCoffeeShops()
    func fetchSuccess(shops: CoffeeShopsEntity)
    func fetchError(message: String)
    func unauthorisedUser()
    
    func tapOnPlacemark(id: Int)
    
    var shops: CoffeeShopsEntity { get set }
}

class MapPresenter: MapPresenterProtocol, MapInteractorOutputProtocol {
    
    var router: MapRouterProtocol?
    var interactor: MapInteractorPtotocol?
    var view: MapViewProtocol?
    
    var shops: CoffeeShopsEntity = []
    
    func fetchCoffeeShops() {
        guard let token = KeychainHelper.shared.getCredentials() else { return }
        interactor?.fetchData(token: token)
    }
    
    func fetchSuccess(shops: [CoffeeShopsEntityElement]) {
        self.shops = shops
        view?.fetchShopSuccess()
    }
    
    func tapOnPlacemark(id: Int) {
        router?.navigateToMenu(id: id)
    }
    
    func fetchError(message: String) {
        view?.showFetchError(message: message)
    }
    
    func unauthorisedUser() {
        view?.unauthorisedUser()
    }
}
