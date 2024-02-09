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
    func showLoginSuccess()
    func showLoginError(message: String)
}

class LoginViewController: UIViewController {
    
    var presenter: LoginPresenterProtocol?
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .left
        label.text = "e-mail"
        label.tintColor = K.Design.primaryTextColor
        return label
    }()
    
    var emailTextField: UITextField = {
        let textField = AuthTextField(symbol: nil, placeholder: "example@example.ru")
        textField.tag = 0
        textField.text = "1234567@gamil.com"
        return textField
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .left
        label.text = "Пароль"
        label.tintColor = K.Design.primaryTextColor
        return label
    }()
    
    var passwordTextField: UITextField = {
        let textField = AuthTextField(symbol: nil, placeholder: "******")
        textField.tag = 1
        textField.isSecureTextEntry = true
        textField.text = "12347889"
        return textField
    }()
    
    var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.tintColor = K.Design.buttonTextColor
        button.backgroundColor = K.Design.buttonColor
        button.layer.borderColor = K.Design.buttonBorderColor?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        return button
    }()

    var emailStack: UIStackView!
    var passwordStack: UIStackView!
    
    let formView: UIView = {
        let view = UIView()
        view.backgroundColor = K.Design.primaryBackroundColor
        return view
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
        
        startObservingKeyobard()
    }
    
    deinit {
        // Unregister from keyboard notifications when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    func startObservingKeyobard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= 40
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    
    func loggingButtonTaped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        presenter?.loginButtonTapped(login: email, password: password)
        view.endEditing(true)
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension LoginViewController: LoginViewProtocol {
    func showLoginSuccess() {
    }
    
    func showLoginError(message: String) {
        print(message)
    }
}

// MARK: - Setup View
private extension LoginViewController {
    func setupView() {
        view.backgroundColor = K.Design.secondBackroundColor
        
        navigationItem.title = "Вход"
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
        
        logInButton.addAction(
            UIAction { [weak self] _ in
                self?.loggingButtonTaped()
            },
            for: .touchUpInside)
        
    }
}

// MARK: - Setting View
private extension LoginViewController {
    func addSubview() {
        
        view.addSubview(formView)
        view.addSubview(separatorView)
        
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
        
        view.addSubview(logInButton)
    }
}

// MARK: - Setup Layout
private extension LoginViewController {
    func setupLayout() {
        
        formView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
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
    
        logInButton.snp.makeConstraints { make in
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
