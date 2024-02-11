//
//  AlertPresenter.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 10/02/2024.
//

import Foundation
import UIKit

enum AlertPresenter {
    static func present(from controller: UIViewController?, with text: String, message: String? = nil, preferredStyle:  UIAlertController.Style = .alert, action: UIAlertAction? = nil) {
        guard let controller = controller else {
            return
        }
        let alertVC = UIAlertController(title: text, message: message, preferredStyle: preferredStyle)
        if let action = action {
            alertVC.addAction(action)
        }
        controller.present(alertVC, animated: true)
        
        if preferredStyle == .actionSheet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alertVC.dismiss(animated: true)
            }
        }
    }
}
