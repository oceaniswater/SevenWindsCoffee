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
        NetworkManager.shared.fetchMenuItems(token: token, locationId: id) { [weak self] result in
            switch result {
            case .success(let items):
                self?.presenter?.fetchSuccess(items: items)
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
