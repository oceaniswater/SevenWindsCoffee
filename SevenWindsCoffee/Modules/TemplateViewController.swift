//
//  TemplateViewController.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 11/02/2024.
//

import UIKit

class TemplateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.Design.secondBackroundColor
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
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
