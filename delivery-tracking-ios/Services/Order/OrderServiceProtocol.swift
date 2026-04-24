//
//  OrderServiceProtocol.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

protocol OrderServiceProtocol {
    func fetchOrders() async throws(OrderServiceError) -> [Order]
}
