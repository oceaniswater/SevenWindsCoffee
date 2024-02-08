//
//  MenuInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import Foundation
import Moya

protocol MenuInteractorPtotocol: AnyInteractorProtocol {
    var presenter: MenuPresenterProtocol? {get set}
    func fetchData(token: String, id: Int)
}

protocol MenuInteractorOutputProtocol: AnyObject {
    func fetchSuccess(items: MenuItemsEntity)
    func fetchError(message: String)
}

class MenuInteractor: MenuInteractorPtotocol {
    var presenter: MenuPresenterProtocol?
    
    var output: MenuInteractorOutputProtocol!
    
    func fetchData(token: String, id: Int) {

        let provider = MoyaProvider<CoffeeShopAPI>()
        
        provider.request(.getMenu(locationId: id, token: token)) { [weak self] result in
            switch result {
            case .success(let response):
                // Handle success
                let data = response.data
                let decodedResponse = try? JSONDecoder().decode(MenuItemsEntity.self, from: data)
                guard let items = decodedResponse else { return }
                self?.presenter?.fetchSuccess(items: items)
            case .failure(let error):
                // Handle error
                self?.presenter?.fetchError(message: error.localizedDescription)
            }
        }
    }
}

