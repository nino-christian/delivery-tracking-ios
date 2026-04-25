//
//  OrderServiceError.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

enum OrderServiceError: Error, Equatable {
    case fetchFailed
    case notFound(id: Int)
}
