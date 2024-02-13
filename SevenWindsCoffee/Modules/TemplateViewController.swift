//
//  TemplateViewController.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 11/02/2024.
//

import UIKit
import SnapKit

class TemplateViewController: UIViewController {
    
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
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup View
private extension TemplateViewController {
    func setupView() {
        
        view.backgroundColor = K.Design.secondBackroundColor
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = K.Design.secondBackroundColor
        appearance.titleTextAttributes = [.foregroundColor:  K.Design.primaryTextColor ?? .brown]
        appearance.largeTitleTextAttributes = [.foregroundColor:  K.Design.primaryTextColor ?? .brown]
        
        navigationController?.navigationBar.tintColor = K.Design.primaryTextColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
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
        
    }
}

// MARK: - Setting
private extension TemplateViewController {
    func addSubview() {
        navigationController?.navigationBar.addSubview(separatorView)
    }
}

// MARK: - Setup Layout
private extension TemplateViewController {
    func setupLayout() {
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
            make.top.equalTo(navigationController?.navigationBar.snp.bottom ?? view.safeAreaLayoutGuide)
        }
    }
}
