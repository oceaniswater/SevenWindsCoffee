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
}

class MenuViewController: UIViewController {
    
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
    
    var onMapButton: UIButton = {
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
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func onMapButtonTaped() {

    }
}

extension MenuViewController: MenuViewProtocol {
    func fetchMenuSuccess() {
        reloadColectionView()
    }
    
    func showFetchError(message: String) {
        //
    }
    

}

// MARK: - Setup View
private extension MenuViewController {
    func setupView() {
        view.backgroundColor = .systemGray
        
        navigationItem.title = "Ближайшие кофейни"
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

        onMapButton.addAction(
            UIAction { [weak self] _ in
                self?.onMapButtonTaped()
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
        view.addSubview(onMapButton)
    }
}

// MARK: - Setup Layout
private extension MenuViewController {
    func setupLayout() {
        
        menuCollection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(onMapButton.snp.top)
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

