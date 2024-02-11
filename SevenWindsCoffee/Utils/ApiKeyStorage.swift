//
//  ApiKeyStorage.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 10/02/2024.
//

import Foundation

enum ApiKeyStorage {
    static let mapkitApiKey = Bundle.main.object(forInfoDictionaryKey: "MAPKIT_API_KEY") as? String ?? ""
}
