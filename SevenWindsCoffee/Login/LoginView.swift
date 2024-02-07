//
//  LoginView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import UIKit
import SnapKit
import Foundation

protocol AnyViewProtocol: AnyObject {
    
}

protocol LoginViewProtocol: AnyViewProtocol {
    var presenter: LoginPresenterProtocol? {get set}
    func showLoginSuccess(token: String, tokenLifetime: TimeInterval)
    func showLoginError(message: String)
}

class LoginViewController: UIViewController {
    
    var presenter: LoginPresenterProtocol?
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .left
        label.text = "e-mail"
        return label
    }()
    
    var emailTextField: UITextField = {
        let textField = AuthTextField(symbol: "envelope", placeholder: "example@example.ru")
        textField.tag = 0
        textField.text = "1234567@gamil.com"
        return textField
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .left
        label.text = "Пароль"
        return label
    }()
    
    var passwordTextField: UITextField = {
        let textField = AuthTextField(symbol: "lock", placeholder: "******")
        textField.tag = 1
        textField.isSecureTextEntry = true
        textField.text = "12347889"
        return textField
    }()
    
    var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        return button
    }()

    var emailStack: UIStackView!
    var passwordStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title directly
        title = "Your Title"
        
        // Alternatively, customize the navigation item
        navigationItem.title = "Your Custom Title"
        
        // You can also customize the appearance of the navigation bar
        navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setupView()

        // Do any additional setup after loading the view.
    }
    
    func loggingButtonTaped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        presenter?.loginButtonTapped(login: email, password: password)
    }
}

extension LoginViewController: LoginViewProtocol {
    func showLoginSuccess(token: String, tokenLifetime: TimeInterval) {
        print(token)
    }
    
    func showLoginError(message: String) {
        print(message)
    }
}

// MARK: - Setup View
private extension LoginViewController {
    func setupView() {
        view.backgroundColor = .white
        
        addSubview()
        setupLayout()
        
        signInButton.addAction(
            UIAction { [weak self] _ in
                self?.loggingButtonTaped()
            },
            for: .touchUpInside)
        
    }
}

// MARK: - Setting View
private extension LoginViewController {
    func addSubview() {
        
        emailStack = UIStackView(arrangedSubviews: [emailLabel, emailTextField])
        emailStack.axis = .vertical
        emailStack.spacing = 2
        emailStack.alignment = .leading
        emailStack.distribution = .fillProportionally
        
        view.addSubview(emailStack)
        
        passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField])
        passwordStack.axis = .vertical
        passwordStack.spacing = 2
        passwordStack.alignment = .leading
        passwordStack.distribution = .fillProportionally
        
        view.addSubview(passwordStack)
        
        view.addSubview(signInButton)
    }
}

// MARK: - Setup Layout
private extension LoginViewController {
    func setupLayout() {
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(339)
        }
        
        emailStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(278)
            make.centerX.equalToSuperview()
            make.height.equalTo(73)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(339)
        }
        
        passwordStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(375)
            make.centerX.equalToSuperview()
            make.height.equalTo(73)
        }
    
        signInButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(478)
            make.width.equalTo(338)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}

#Preview(traits: .defaultLayout, body: {
    let vc = LoginViewController()
    return vc
})
