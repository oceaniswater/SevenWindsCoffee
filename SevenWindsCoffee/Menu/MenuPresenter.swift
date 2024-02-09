//
//  MenuPresenter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import Foundation

protocol MenuPresenterProtocol {
    var router: MenuRouterProtocol? {get set}
    var interactor: MenuInteractorPtotocol? {get set}
    var view: MenuViewProtocol? {get set}
    
    func fetchMenuItems()
    func fetchSuccess(items: MenuItemsEntity)
    func fetchError(message: String)
    
    var id: Int {get set}
    var items: MenuItemsEntity { get set }
    func numberOfSection() -> Int
    func numberOfItemsInSection(in section: Int) -> Int
}

class MenuPresenter: MenuPresenterProtocol, MenuInteractorOutputProtocol {
    
    var router: MenuRouterProtocol?
    var interactor: MenuInteractorPtotocol?
    var view: MenuViewProtocol?
    
    var id: Int
    var items: MenuItemsEntity = []
    
    init(router: MenuRouterProtocol? = nil, interactor: MenuInteractorPtotocol? = nil, view: MenuViewProtocol? = nil, id: Int, items: MenuItemsEntity = []) {
        self.router = router
        self.interactor = interactor
        self.view = view
        self.id = id
        self.items = items
    }
    
    func fetchMenuItems() {
        guard let token = KeychainHelper.shared.getCredentials() else { return }
        interactor?.fetchData(token: token, id: self.id)
    }
    
    func fetchSuccess(items: MenuItemsEntity) {
        self.items = items
        view?.fetchMenuSuccess()
    }
    
    func fetchError(message: String) {
        view?.showFetchError(message: message)
    }
    
    func numberOfSection() -> Int {
        1
    }
    
    func numberOfItemsInSection(in section: Int) -> Int {
        return self.items.count
    }
}


