//
//  ProductFeatureError.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

enum ProductFeatureError: Error, Equatable, LocalizedError {
    case fetchFailed
    case notFound(id: Int)

    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Failed to fetch product. Please try again."
        case .notFound(let id):
            return "Product with ID \(id) not found."
        }
    }
}
