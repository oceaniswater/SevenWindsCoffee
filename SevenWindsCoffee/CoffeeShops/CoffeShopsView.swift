//
//  CoffeShopsView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import UIKit
import SnapKit
import Foundation

protocol CoffeeShopsViewProtocol: AnyViewProtocol {
    var presenter: CoffeeShopsPresenterProtocol? {get set}
    func showLoginSuccess(token: String, tokenLifetime: TimeInterval)
    func showLoginError(message: String)
}

class CoffeeShopsViewController: UIViewController {
    
    var presenter: CoffeeShopsPresenterProtocol?
    
    var onMapButton: UIButton = {
        let button = UIButton()
        button.setTitle("На карте", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Coffe Shops"
        navigationController?.navigationBar.backgroundColor = .systemGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        
        setupView()
    }
    
    func onMapButtonTaped() {

    }
}

extension CoffeeShopsViewController: CoffeeShopsViewProtocol {
    func showLoginSuccess(token: String, tokenLifetime: TimeInterval) {
        print(token)
    }
    
    func showLoginError(message: String) {
        print(message)
    }
}

// MARK: - Setup View
private extension CoffeeShopsViewController {
    func setupView() {
        view.backgroundColor = .systemGray
        
        addSubview()
        setupLayout()
        
        onMapButton.addAction(
            UIAction { [weak self] _ in
                self?.onMapButtonTaped()
            },
            for: .touchUpInside)
        
    }
}

// MARK: - Setting View
private extension CoffeeShopsViewController {
    func addSubview() {
        view.backgroundColor = .white
        view.addSubview(onMapButton)
    }
}

// MARK: - Setup Layout
private extension CoffeeShopsViewController {
    func setupLayout() {
        
        onMapButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(732)
            make.width.equalTo(338)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}

#Preview(traits: .defaultLayout, body: {
    let vc = CoffeeShopsViewController()
    return vc
})
