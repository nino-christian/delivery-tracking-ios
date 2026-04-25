//
//  OrderFeatureError.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

enum OrderFeatureError: Error, Equatable, LocalizedError {
    case fetchFailed

    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Failed to fetch orders. Please try again."
        }
    }
}
