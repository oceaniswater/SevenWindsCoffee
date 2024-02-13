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
    func unauthorisedUser()
}

class OrderViewController: TemplateViewController {
    
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
        button.tintColor = K.Design.buttonTextColor
        button.backgroundColor = K.Design.buttonColor
        button.layer.borderColor = K.Design.buttonBorderColor?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        return button
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Время ожидания заказа\n15 минут!\nСпасибо, что выбрали нас!"
        label.textColor = K.Design.primaryTextColor
        label.font = UIFont(name: "SFUIDisplay-Medium", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // MARK: - Lifecycle
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
    
    func orderButtonTaped() {
    }
}

// MARK: - OrderViewProtocol
extension OrderViewController: OrderViewProtocol {
    func fetchShopSuccess() {
        reloadTableView()
    }
    
    func showFetchError(message: String) {
        // show error
    }
    
    func unauthorisedUser() {
        AlertPresenter.present(from: self, with: "Ошибка авторизации", message: "Зарегистрируйтесь или войдите с помощью существущего логина и пароля.", action: UIAlertAction(title: "Ок", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }))
    }
}

// MARK: - Setup View
private extension OrderViewController {
    func setupView() {
        navigationItem.title = "Ваш заказ"
        
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
        view.addSubview(tableView)
        view.addSubview(orderButton)
        view.addSubview(textLabel)
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
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(486)
            make.height.equalTo(87)
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

