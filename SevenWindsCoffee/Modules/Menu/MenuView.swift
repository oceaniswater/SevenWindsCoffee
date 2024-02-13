//
//  MenuView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import UIKit
import SnapKit
import Foundation

protocol MenuViewProtocol: AnyViewProtocol {
    var presenter: MenuPresenterProtocol? {get set}
    func fetchMenuSuccess()
    func showFetchError(message: String)
    func customError(title: String, message: String)
    func unauthorisedUser()
}

class MenuViewController: TemplateViewController {
    
    var presenter: MenuPresenterProtocol?
    
    var menuCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = K.Design.secondBackroundColor
        return collection
    }()
    
    var goToOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти к оплате", for: .normal)
        button.tintColor = K.Design.buttonTextColor
        button.backgroundColor = K.Design.buttonColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
        
        presenter?.fetchMenuItems()
    }
    
    func goToOrderButtonTaped() {
        presenter?.tapOnGoToOrderButton()
    }
}

extension MenuViewController: MenuViewProtocol {
    func unauthorisedUser() {
        AlertPresenter.present(from: self, with: "Ошибка авторизации", message: "Зарегистрируйтесь или войдите с помощью существущего логина и пароля.", action: UIAlertAction(title: "Ок", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }))
    }
    
    func fetchMenuSuccess() {
        reloadColectionView()
    }
    
    func showFetchError(message: String) {
        AlertPresenter.present(from: self, with: "Ошибка", message: message, preferredStyle: .actionSheet)
    }
    
    func customError(title: String, message: String) {
        AlertPresenter.present(from: self, with: title, message: message, preferredStyle: .actionSheet)
    }
    
    
}

// MARK: - Setup View
private extension MenuViewController {
    func setupView() {
        navigationItem.title = "Меню"
        
        addSubview()
        setupLayout()
        
        goToOrderButton.addAction(
            UIAction { [weak self] _ in
                self?.goToOrderButtonTaped()
            },
            for: .touchUpInside)
    }
}

// MARK: - MenuCellDelegate
extension MenuViewController: MenuCellDelegate {
    func didCountChanged(count: UInt, identifier: Int?) {
        if let identifier = identifier {
            guard let orders = presenter?.orders as? OrderEntity else { return }
            
            let updatedOrders: OrderEntity = orders.map { order in
                var updatedOrder = order
                if order.item.id == identifier {
                    updatedOrder.count = count
                }
                return updatedOrder
            }
            presenter?.orders = updatedOrders
        }
    }
}

// MARK: - Setting View
private extension MenuViewController {
    func addSubview() {
        view.addSubview(menuCollection)
        view.addSubview(goToOrderButton)
    }
}

// MARK: - Setup Layout
private extension MenuViewController {
    func setupLayout() {
        
        menuCollection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(goToOrderButton.snp.top)
        }
        
        goToOrderButton.snp.makeConstraints { make in
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
