//
//  KeychainHelper.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation
import Security
import KeychainSwift

class KeychainHelper {
    static let shared = KeychainHelper()
    private let keychain = KeychainSwift()

    private init() {}

    func saveToken(token: String) {
        keychain.set(token, forKey: "token")
    }

    func getCredentials() -> String? {
        let token = keychain.get("token")
        return token
    }

    func deleteCredentials() {
        keychain.delete("token")
    }
}
