//
//  OrderView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import UIKit
import SnapKit
import Foundation

protocol OrderViewProtocol: AnyViewProtocol {
    var presenter: OrderPresenterProtocol? {get set}
    func fetchShopSuccess()
    func showFetchError(message: String)
}

class OrderViewController: UIViewController {
    
    var presenter: OrderPresenterProtocol?
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = K.Design.primaryBackroundColor
        table.separatorStyle = .none
        return table
    }()
    
    var orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
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
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func orderButtonTaped() {
    }
}

extension OrderViewController: OrderViewProtocol {
    func fetchShopSuccess() {
        reloadTableView()
    }
    
    func showFetchError(message: String) {
        print(message)
    }
}

// MARK: - Setup View
private extension OrderViewController {
    func setupView() {
        view.backgroundColor = .systemGray
        
        navigationItem.title = "Ваш заказ"
        navigationController?.navigationBar.backgroundColor = K.Design.secondBackroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Design.primaryTextColor ?? .black]
        
        let backButton = UIButton(type: .custom)
        backButton.tintColor = K.Design.primaryTextColor
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addAction(
            UIAction { [weak self] _ in
                self?.backButtonTapped()
            },
            for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        addSubview()
        setupLayout()

        orderButton.addAction(
            UIAction { [weak self] _ in
                self?.orderButtonTaped()
            },
            for: .touchUpInside)
        
    }
}

// MARK: - Setting View
private extension OrderViewController {
    func addSubview() {
        view.backgroundColor = K.Design.secondBackroundColor
        view.addSubview(tableView)
        view.addSubview(separatorView)
        view.addSubview(orderButton)
    }
}

// MARK: - Setup Layout
private extension OrderViewController {
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
        
        orderButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(732)
            make.width.equalTo(338)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}

#Preview(traits: .defaultLayout, body: {
    let vc = OrderViewController()
    return vc
})
