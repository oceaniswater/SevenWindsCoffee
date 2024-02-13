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
    func displayValidationError(_ error: ValidationError)
}

class LoginViewController: TemplateViewController {
    
    var presenter: LoginPresenterProtocol?
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15.0)
        label.textAlignment = .left
        label.text = "e-mail"
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    var emailTextField: UITextField = {
        let textField = AuthTextField(symbol: nil, placeholder: "example@example.ru")
        textField.tag = 0
        return textField
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15.0)
        label.textAlignment = .left
        label.text = "Пароль"
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    var passwordTextField: UITextField = {
        let textField = AuthTextField(symbol: nil, placeholder: "******")
        textField.tag = 1
        textField.isSecureTextEntry = true
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        startObservingKeyobard()
        setupUITextFieldDelegate()
        setupGestureEndEditing()
    }
    
    deinit {
        // Unregister from keyboard notifications when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    func loginButtonTaped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        if let valid = presenter?.validateFields(email: email, password: password), valid == true {
            presenter?.loginButtonTapped(login: email, password: password)
            view.endEditing(true)
        }
    }
}

// MARK: - LoginViewProtocol
extension LoginViewController: LoginViewProtocol {
    func showLoginSuccess() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func showLoginError(message: String) {
        AlertPresenter.present(from: self, with: "Ошибка", message: message, action: UIAlertAction(title: "Ok", style: .default))
    }
    
    func displayValidationError(_ error: ValidationError) {
        switch error {
        case .emptyFieldsError:
            // Show error message for empty fields
            AlertPresenter.present(from: self, with: "Ошибка", message: "Оба поля должны быть заполненны.", action: UIAlertAction(title: "Ok", style: .default))
            break
        case .emailNotValidError:
            // Show error message for invalid email
            AlertPresenter.present(from: self, with: "Ошибка", message: "Некорректный email.", action: UIAlertAction(title: "Ok", style: .default))
            break
        case .passwordNotMaching:
            AlertPresenter.present(from: self, with: "Ошибка", message: "Пароли не совпадают.", action: UIAlertAction(title: "Ok", style: .default))
            break
        }
    }
}

// MARK: - Observe keyboard
private extension LoginViewController {
    private func startObservingKeyobard() {
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
        if formView.frame.origin.y == 0 {
            formView.frame.origin.y -= 40
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if formView.frame.origin.y != 0 {
            formView.frame.origin.y = 0
        }
    }
}

// MARK: - Setup View
private extension LoginViewController {
    func setupView() {
        navigationItem.title = "Вход"
        
        addSubview()
        setupLayout()
        
        logInButton.addAction(
            UIAction { [weak self] _ in
                self?.loginButtonTaped()
            },
            for: .touchUpInside)
    }
}

// MARK: - Setting View
private extension LoginViewController {
    func addSubview() {
        view.addSubview(formView)
        
        emailStack = UIStackView(arrangedSubviews: [emailLabel, emailTextField])
        emailStack.axis = .vertical
        emailStack.spacing = 2
        emailStack.alignment = .leading
        emailStack.distribution = .fillProportionally
        
        formView.addSubview(emailStack)
        
        passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField])
        passwordStack.axis = .vertical
        passwordStack.spacing = 2
        passwordStack.alignment = .leading
        passwordStack.distribution = .fillProportionally
        
        formView.addSubview(passwordStack)
        
        formView.addSubview(logInButton)
    }
}

// MARK: - Setup Layout
private extension LoginViewController {
    func setupLayout() {
        
        formView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
