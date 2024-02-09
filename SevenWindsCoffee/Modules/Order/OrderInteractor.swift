//
//  OrderInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import Foundation
import Moya

protocol OrderInteractorPtotocol: AnyInteractorProtocol {
    var presenter: OrderPresenterProtocol? {get set}
    func fetchData(token: String)
}

protocol OrderInteractorOutputProtocol: AnyObject {
    func fetchSuccess(items: OrderEntity)
    func fetchError(message: String)
}

class OrderInteractor: OrderInteractorPtotocol {
    var presenter: OrderPresenterProtocol?
    
    var output: OrderInteractorOutputProtocol!
    
    func fetchData(token: String) {

        let provider = MoyaProvider<CoffeeShopAPI>()
        
        provider.request(.getLocations(token: token)) { [weak self] result in
            switch result {
            case .success(let response):
                // Handle success
                let data = response.data
                let decodedResponse = try? JSONDecoder().decode(CoffeeShopsEntity.self, from: data)
                guard let shops = decodedResponse else { return }
//                self?.presenter?.fetchSuccess(shops: shops)
            case .failure(let error):
                // Handle error
                self?.presenter?.fetchError(message: error.localizedDescription)
            }
        }
    }
}

