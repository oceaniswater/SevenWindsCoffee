//
//  RegistrationEntity.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import Foundation

// MARK: - RegistrationEntity
struct RegistrationEntity: Codable {
    let token: String
    let tokenLifetime: TimeInterval
}
