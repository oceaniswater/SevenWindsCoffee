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
    func showRegistrationError(message: String)
    func displayValidationError(_ error: ValidationError)
}

class RegistrationViewController: TemplateViewController {
    
    var presenter: RegistrationPresenterProtocol?
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
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
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
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
    
    var passwordRepeatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
        label.textAlignment = .left
        label.text = "Повторите пароль"
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    var passwordRepeatTextField: UITextField = {
        let textField = AuthTextField(symbol: nil, placeholder: "******")
        textField.tag = 2
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 18)
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
    
    func registerButtonTaped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let password2 = passwordRepeatTextField.text else { return }
        if let isValid = presenter?.validateFields(email: email, password: password, password2: password2), isValid == true {
            presenter?.registerButtonTapped(login: email, password: password)
            view.endEditing(true)
        }
    }
}

// MARK: - Observe keyboard
extension RegistrationViewController {
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
        if formView.frame.origin.y == 0 {
            formView.frame.origin.y -= 90
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if formView.frame.origin.y != 0 {
            formView.frame.origin.y = 0
        }
    }
}

// MARK: - RegistrationViewProtocol
extension RegistrationViewController: RegistrationViewProtocol {
    func registerSuccess() {
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordRepeatTextField.text = ""
    }
    
    func showRegistrationError(message: String) {
        AlertPresenter.present(from: self, with: "Ошибка", message: message, action: UIAlertAction(title: "Ok", style: .default))
    }
    
    func displayValidationError(_ error: ValidationError) {
        switch error {
        case .emptyFieldsError:
            // Show error message for empty fields
            AlertPresenter.present(from: self, with: "Ошибка", message: "Все поля должны быть заполненны.", action: UIAlertAction(title: "Ok", style: .default))
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

// MARK: - Setup View
private extension RegistrationViewController {
    func setupView() {
        navigationItem.title = "Регистрация"
        navigationItem.leftBarButtonItem?.isHidden = true
        
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
        
        passwordRepeatStack = UIStackView(arrangedSubviews: [passwordRepeatLabel, passwordRepeatTextField])
        passwordRepeatStack.axis = .vertical
        passwordRepeatStack.spacing = 2
        passwordRepeatStack.alignment = .leading
        passwordRepeatStack.distribution = .fillProportionally
        
        formView.addSubview(passwordRepeatStack)
        
        formView.addSubview(registerButton)
    }
}

// MARK: - Setup Layout
private extension RegistrationViewController {
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
