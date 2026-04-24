//
//  Product.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

struct Product: Equatable, Identifiable, Codable {
    let id: Int
    var name: String
    var manufacturer: String
}
