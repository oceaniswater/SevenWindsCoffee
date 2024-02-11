//
//  OrderRouter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import UIKit
import Foundation

protocol OrderRouterProtocol: AnyRouterProtocol {
    static func start(items: OrderEntity) -> AnyRouterProtocol
}

class OrderRouter: OrderRouterProtocol {
    weak var entryPoint: EntryPoint?
    
    static func start() -> AnyRouterProtocol {
        let router = OrderRouter()
        return router
    }

    static func start(items: OrderEntity) -> AnyRouterProtocol {
        let router = OrderRouter()
        
        let view: OrderViewProtocol = OrderViewController()
        var interactor: OrderInteractorPtotocol = OrderInteractor()
        var presenter: OrderPresenterProtocol = OrderPresenter(items: items)
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entryPoint = view as? EntryPoint
        
        return router
    }
}

