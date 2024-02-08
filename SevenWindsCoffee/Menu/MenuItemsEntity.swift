//
//  MenuItemsEntity.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import Foundation

// MARK: - MenuItemsEntityElement
struct MenuItemsEntityElement: Codable {
    let id: Int
    let name, imageURL: String
    let price: Int
}

typealias MenuItemsEntity = [MenuItemsEntityElement]
