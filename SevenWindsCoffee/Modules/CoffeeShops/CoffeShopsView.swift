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
    func fetchShopSuccess()
    func showFetchError(message: String)
}

class CoffeeShopsViewController: TemplateViewController {
    
    var presenter: CoffeeShopsPresenterProtocol?
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = K.Design.primaryBackroundColor
        table.separatorStyle = .none
        return table
    }()
    
    var onMapButton: UIButton = {
        let button = UIButton()
        button.setTitle("На карте", for: .normal)
        button.tintColor = K.Design.buttonTextColor
        button.backgroundColor = K.Design.buttonColor
        button.layer.borderColor = K.Design.buttonBorderColor?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = K.Design.secondBackroundColor
        view.layer.borderColor = K.Design.separatorLineColor?.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
        LocationManager.shared.startUpdatingLocation { [weak self] success in
            guard let self = self else { return }
            
            if success {
                // User granted location permission, reload table view
                self.reloadTableView()
            } else {
                // Handle case where location permission is not granted
            }
        }
        
        presenter?.fetchCoffeeShops()
    }
    
    func onMapButtonTaped() {
        presenter?.tapOnMapButton()
    }
}

extension CoffeeShopsViewController: CoffeeShopsViewProtocol {
    func fetchShopSuccess() {
        reloadTableView()
    }
    
    func showFetchError(message: String) {
        print(message)
    }
}

// MARK: - Setup View
private extension CoffeeShopsViewController {
    func setupView() {
        
        navigationItem.title = "Ближайшие кофейни"
        
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
        view.addSubview(tableView)
        view.addSubview(separatorView)
        view.addSubview(onMapButton)
    }
}

// MARK: - Setup Layout
private extension CoffeeShopsViewController {
    func setupLayout() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
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
