//
//  MapRouter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 10/02/2024.
//

import UIKit
import Foundation

protocol MapRouterProtocol: AnyRouterProtocol {
    func navigateToMenu(id: Int)
}

class MapRouter: MapRouterProtocol {
    weak var entryPoint: EntryPoint?
    
    static func start() -> AnyRouterProtocol {
        let router = MapRouter()
        
        let view: MapViewProtocol = MapViewController()
        var interactor: MapInteractorPtotocol = MapInteractor()
        var presenter: MapPresenterProtocol = MapPresenter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entryPoint = view as? EntryPoint
        
        return router
    }
    
    func navigateToMenu(id: Int) {
        let menuRouter = MenuRouter.start(id: id)
        guard let vc = menuRouter.entryPoint else { return }
        entryPoint?.navigationController?.pushViewController(vc, animated: true)
    }
}
