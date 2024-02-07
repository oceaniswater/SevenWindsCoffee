//
//  CoffeeShopsRouter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import UIKit
import Foundation

protocol CoffeeShopsRouterProtocol: AnyRouterProtocol {
}

class CoffeeShopsRouter: CoffeeShopsRouterProtocol {
    weak var entryPoint: EntryPoint?
    
    static func start() -> AnyRouterProtocol {
        let router = CoffeeShopsRouter()
        
        let view: CoffeeShopsViewProtocol = CoffeeShopsViewController()
        var interactor: CoffeeShopsInteractorPtotocol = CoffeeShopsInteractor()
        var presenter: CoffeeShopsPresenterProtocol = CoffeShopsPresenter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entryPoint = view as? EntryPoint
        
        return router
    }
    
    func goToCofeeShopsList() {
        
    }
    
    
}
