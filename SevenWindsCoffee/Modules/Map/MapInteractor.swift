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
        NetworkManager.shared.fetchCoffeeShops(token: token) { [weak self] result in
            switch result {
            case .success(let coffeeShops):
                self?.presenter?.fetchSuccess(shops: coffeeShops)
            case .failure(let networkError):
                switch networkError {
                case .unauthorised:
                    self?.presenter?.unauthorisedUser()
                    break
                case .invalidStatusCode(_):
                    self?.presenter?.fetchError(message: networkError.localizedDescription)
                    break
                case .decodingError(_):
                    self?.presenter?.fetchError(message: networkError.localizedDescription)
                    break
                case .moyaError(_):
                    self?.presenter?.fetchError(message: networkError.localizedDescription)
                    break
                case .userExist:
                    break
                }
            }
        }
    }
}

