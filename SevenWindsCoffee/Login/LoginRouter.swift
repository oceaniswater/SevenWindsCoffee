//
//  LoginRouter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import UIKit
import Foundation

typealias EntryPoint = AnyViewProtocol & UIViewController

protocol AnyRouterProtocol {
    var entryPoint: EntryPoint? {get}
    static func start() -> AnyRouterProtocol
}

protocol LoginRouterProtocol: AnyRouterProtocol {
}

class LoginRouter: LoginRouterProtocol {
    var entryPoint: EntryPoint?
    
    static func start() -> AnyRouterProtocol {
        let router = LoginRouter()
        
        let view: LoginViewProtocol = LoginViewController()
        var interactor: LoginInteractorPtotocol = LoginInteractor()
        var presenter: LoginPresenterProtocol = LoginPresenter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entryPoint = view as? EntryPoint
        
        return router
    }
    
    
}
