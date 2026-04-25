//
//  OrderDetailFeatureError.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

enum OrderDetailFeatureError: Error, Equatable, LocalizedError {
    case fetchFailed
    case notFound(id: Int)

    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Failed to load order details. Please try again."
        case .notFound(let id):
            return "Order #\(id) could not be found."
        }
    }
}
