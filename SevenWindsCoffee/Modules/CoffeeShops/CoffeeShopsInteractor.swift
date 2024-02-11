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
                    self?.presenter?.fetchError(message: networkError.localizedDescription)
                    break
                }
            }
        }
    }
}
