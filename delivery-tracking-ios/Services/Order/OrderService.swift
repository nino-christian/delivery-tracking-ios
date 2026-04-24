//
//  OrderService.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

class OrderService {
    func fetchOrders() async throws(OrderServiceError) -> [Order] {
        do {
            try await Task.sleep(for: .seconds(1))
            return StubData.orders
        } catch {
            throw .fetchFailed
        }
    }
}
