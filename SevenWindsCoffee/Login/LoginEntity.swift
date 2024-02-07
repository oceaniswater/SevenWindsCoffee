//
//  LoginEntity.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation

// MARK: - LoginEntity
struct LoginEntity: Codable {
    let token: String
    let tokenLifetime: TimeInterval
}
