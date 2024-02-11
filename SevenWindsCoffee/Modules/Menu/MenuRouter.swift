//
//  MenuRouter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import UIKit
import Foundation

protocol MenuRouterProtocol: AnyRouterProtocol {
    static func start(id: Int) -> AnyRouterProtocol
    func navigateToOrder(with order: OrderEntity)
}

class MenuRouter: MenuRouterProtocol {
    weak var entryPoint: EntryPoint?
    
    static func start() -> AnyRouterProtocol {
        let router = MenuRouter()
        
        return router
    }
    
    static func start(id: Int) -> AnyRouterProtocol {
        let router = MenuRouter()
        
        let view: MenuViewProtocol = MenuViewController()
        var interactor: MenuInteractorPtotocol = MenuInteractor()
        var presenter: MenuPresenterProtocol = MenuPresenter(id: id)
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entryPoint = view as? EntryPoint
        
        return router
    }
    
    func navigateToOrder(with order: OrderEntity) {
        let orderRouter = OrderRouter.start(items: order)
        guard let vc = orderRouter.entryPoint else { return }
        entryPoint?.navigationController?.pushViewController(vc, animated: true)
    }
}
