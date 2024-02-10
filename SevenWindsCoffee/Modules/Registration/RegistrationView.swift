//
//  RegistrationView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import UIKit
import SnapKit
import Foundation

protocol RegistrationViewProtocol: AnyViewProtocol {
    var presenter: RegistrationPresenterProtocol? {get set}
    func registerSuccess()
    func showLoginError(message: String)
}

class RegistrationViewController: UIViewController {
    
    var presenter: RegistrationPresenterProtocol?
    
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
        return textField
    }()
    
    var passwordRepeatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .left
        label.text = "Повторите пароль"
        label.tintColor = K.Design.primaryTextColor
        return label
    }()
    
    var passwordRepeatTextField: UITextField = {
        let textField = AuthTextField(symbol: nil, placeholder: "******")
        textField.tag = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.tintColor = K.Design.buttonTextColor
        button.backgroundColor = K.Design.buttonColor
        button.layer.borderColor = K.Design.buttonBorderColor?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        return button
    }()

    var emailStack: UIStackView!
    var passwordStack: UIStackView!
    var passwordRepeatStack: UIStackView!
    
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
            view.frame.origin.y -= 90
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    
    func registerButtonTaped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let password2 = passwordRepeatTextField.text else { return }
        guard !email.isEmpty, !password.isEmpty, !password2.isEmpty else {
            AlertPresenter.present(from: self, with: "Ошибка", message: "Оба поля должны быть заполнены.", action: UIAlertAction(title: "Ok", style: .default))
            return }
        guard password == password2 else {
            AlertPresenter.present(from: self, with: "Ошибка", message: "Пароли должны совпадать.", action: UIAlertAction(title: "Ok", style: .default))
            return }
        presenter?.loginButtonTapped(login: email, password: password)
        view.endEditing(true)
    }
}

extension RegistrationViewController: RegistrationViewProtocol {
    func registerSuccess() {
    }
    
    func showLoginError(message: String) {
        print(message)
    }
}

// MARK: - Setup View
private extension RegistrationViewController {
    func setupView() {
        view.backgroundColor = K.Design.secondBackroundColor
        
        navigationItem.title = "Регистрация"
        navigationController?.navigationBar.backgroundColor = K.Design.secondBackroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Design.primaryTextColor ?? .black]
        
        addSubview()
        setupLayout()
        
        registerButton.addAction(
            UIAction { [weak self] _ in
                self?.registerButtonTaped()
            },
            for: .touchUpInside)
        
    }
}

// MARK: - Setting View
private extension RegistrationViewController {
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
        
        passwordRepeatStack = UIStackView(arrangedSubviews: [passwordRepeatLabel, passwordRepeatTextField])
        passwordRepeatStack.axis = .vertical
        passwordRepeatStack.spacing = 2
        passwordRepeatStack.alignment = .leading
        passwordRepeatStack.distribution = .fillProportionally
        
        view.addSubview(passwordRepeatStack)
        
        view.addSubview(registerButton)
    }
}

// MARK: - Setup Layout
private extension RegistrationViewController {
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
        
        passwordRepeatTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(339)
        }
        
        passwordStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(375)
            make.centerX.equalToSuperview()
            make.height.equalTo(73)
        }
        
        passwordRepeatStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(472)
            make.centerX.equalToSuperview()
            make.height.equalTo(73)
        }
        
        
    
        registerButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(575)
            make.width.equalTo(338)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}


#Preview(traits: .defaultLayout, body: {
    let view = RegistrationViewController()
    return view
})

