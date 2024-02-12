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
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
