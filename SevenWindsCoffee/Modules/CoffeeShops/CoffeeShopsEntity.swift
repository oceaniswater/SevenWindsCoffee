//
//  CoffeeShopsEntity.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation

// MARK: - CoffeeShopsEntityElement
struct CoffeeShopsEntityElement: Codable {
    let id: Int
    let name: String
    let point: Point
}

// MARK: - Point
struct Point: Codable {
    let latitude, longitude: String
}

typealias CoffeeShopsEntity = [CoffeeShopsEntityElement]
