//
//  CoffeeShopsRouter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import UIKit
import Foundation

protocol CoffeeShopsRouterProtocol: AnyRouterProtocol {
    func navigateToMenu(id: Int)
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
    
    func navigateToMenu(id: Int) {
        let menuRouter = MenuRouter.start()
        guard let vc = menuRouter.entryPoint else { return }
        entryPoint?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
