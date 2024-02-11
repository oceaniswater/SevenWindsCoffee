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
}

class MenuViewController: TemplateViewController {
    
    var presenter: MenuPresenterProtocol?
    
    var menuCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    var goToOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти к оплате", for: .normal)
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
        setupCollectionView()
        
        presenter?.fetchMenuItems()
    }
    
    func goToOrderButtonTaped() {
        presenter?.tapOnGoToOrderButton()
    }
}

extension MenuViewController: MenuViewProtocol {
    func fetchMenuSuccess() {
        reloadColectionView()
    }
    
    func showFetchError(message: String) {
        //
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

// MARK: - Setting View
private extension MenuViewController {
    func addSubview() {
        view.backgroundColor = K.Design.secondBackroundColor
        view.addSubview(menuCollection)
        view.addSubview(separatorView)
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
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        goToOrderButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(732)
            make.width.equalTo(338)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}

extension MenuViewController: MenuCellDelegate {
    func didCountChanged(count: UInt, identifier: Int?) {
        // Handle the count change, along with the identifier
        if let identifier = identifier {
            // Create a new array with updated values
            guard let orders = presenter?.orders as? OrderEntity else { return }
            
            let updatedOrders: OrderEntity = orders.map { order in
                var updatedOrder = order
                if order.item.id == identifier {
                    updatedOrder.count = count
                }
                return updatedOrder
            }
            
            // Update the original orders array
            presenter?.orders = updatedOrders
        }
        
        print(presenter?.orders)
    }
}

#Preview(traits: .defaultLayout, body: {
    let vc = CoffeeShopsViewController()
    return vc
})

