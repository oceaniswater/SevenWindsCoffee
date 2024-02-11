//
//  ValidationError.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 11/02/2024.
//

import Foundation

enum ValidationError: Error {
    case emptyFieldsError
    case emailNotValidError
    case passwordNotMaching
}
