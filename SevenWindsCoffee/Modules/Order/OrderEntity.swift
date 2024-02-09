//
//  OrderEntity.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import Foundation

// MARK: - OrderEntityElement
struct OrderEntityElement: Codable {
    var item: MenuItemsEntityElement
    var count: UInt
}

typealias OrderEntity = [OrderEntityElement]
