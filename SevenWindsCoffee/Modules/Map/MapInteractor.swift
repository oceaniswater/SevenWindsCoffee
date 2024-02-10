//
//  MapInteractor.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 10/02/2024.
//

import Foundation
import Moya

protocol MapInteractorPtotocol: AnyInteractorProtocol {
    var presenter: MapPresenterProtocol? {get set}
    func fetchData(token: String)
}

protocol MapInteractorOutputProtocol: AnyObject {
    func fetchSuccess(shops: CoffeeShopsEntity)
    func fetchError(message: String)
}

class MapInteractor: MapInteractorPtotocol {
    var presenter: MapPresenterProtocol?
    
    var output: MapInteractorOutputProtocol!
    
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

