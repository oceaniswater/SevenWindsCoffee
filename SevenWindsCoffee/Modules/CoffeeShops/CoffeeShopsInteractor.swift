//
//  CoffeeShopsInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation
import Moya

protocol CoffeeShopsInteractorPtotocol: AnyInteractorProtocol {
    var presenter: CoffeeShopsPresenterProtocol? {get set}
    func fetchData(token: String)
}

protocol CoffeeShopsInteractorOutputProtocol: AnyObject {
    func fetchSuccess(shops: CoffeeShopsEntity)
    func fetchError(message: String)
}

class CoffeeShopsInteractor: CoffeeShopsInteractorPtotocol {
    var presenter: CoffeeShopsPresenterProtocol?
    
    var output: CoffeeShopsInteractorOutputProtocol!
    
    func fetchData(token: String) {

        let provider = MoyaProvider<CoffeeShopAPI>()
        
        provider.request(.getLocations(token: token)) { [weak self] result in
            switch result {
            case .success(let response):
                // Handle success
                let data = response.data
                let decodedResponse = try? JSONDecoder().decode(CoffeeShopsEntity.self, from: data)
                guard let shops = decodedResponse else { return }
                self?.presenter?.fetchSuccess(shops: shops)
            case .failure(let error):
                // Handle error
                self?.presenter?.fetchError(message: error.localizedDescription)
            }
        }
    }
}
