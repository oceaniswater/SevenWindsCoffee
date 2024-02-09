//
//  RegistrationRouter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import UIKit
import Foundation

protocol RegistrationRouterProtocol: AnyRouterProtocol {
    func navigateToLogin()
}

class RegistrationRouter: RegistrationRouterProtocol {
    weak var entryPoint: EntryPoint?
    
    static func start() -> AnyRouterProtocol {
        let router = RegistrationRouter()
        
        let view: RegistrationViewProtocol = RegistrationViewController()
        var interactor: RegistrationInteractorPtotocol = RegistrationInteractor()
        var presenter: RegistrationPresenterProtocol = RegistrationPresenter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entryPoint = view as? EntryPoint
        
        return router
    }
    
    func navigateToLogin() {
        let loginRouter = LoginRouter.start()
        guard let vc = loginRouter.entryPoint else { return }
        entryPoint?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

