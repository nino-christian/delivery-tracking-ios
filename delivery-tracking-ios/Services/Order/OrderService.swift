//
//  OrderService.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

struct OrderService: OrderServiceProtocol {

    func fetchOrders() async throws(OrderServiceError) -> [Order] {
        try? await Task.sleep(for: .seconds(1))
        if Bool.random() { throw .fetchFailed }
        return StubData.orders
    }

    func fetchOrder(id: Int) async throws(OrderServiceError) -> Order {
        try? await Task.sleep(for: .seconds(1))
        if Bool.random() { throw .fetchFailed }
        guard let order = StubData.order(id: id) else { throw .notFound(id: id) }
        return order
    }
}
