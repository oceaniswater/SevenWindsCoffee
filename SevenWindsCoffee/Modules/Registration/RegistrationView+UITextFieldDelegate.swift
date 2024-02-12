//
//  RegistrationView+UITextFieldDelegate.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 12/02/2024.
//

import UIKit

extension RegistrationViewController: UITextFieldDelegate {
    
    func setupUITextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordRepeatTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            passwordRepeatTextField.becomeFirstResponder()
        case 2:
            registerButtonTaped()
        default:
            break
        }
        
        return true
    }
    
    func setupGestureEndEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        // Dismiss the keyboard and resign first responder status
        view.endEditing(true)
    }
}
