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
    
    // делаю это чтобы отловить протухший токен на всякий случай
    func fetchData(token: String) {
        NetworkManager.shared.fetchCoffeeShops(token: token) { [weak self] result in
            switch result {
            case .success(let coffeeShops):
                break
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

