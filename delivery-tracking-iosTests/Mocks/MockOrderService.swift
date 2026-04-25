//
//  MockOrderService.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

@testable import delivery_tracking_ios

final class MockOrderService: OrderServiceProtocol {
    var fetchOrdersResult: Result<[Order], OrderServiceError> = .success(StubData.orders)
    var fetchOrderResult: Result<Order, OrderServiceError> = .success(StubData.orders[0])

    func fetchOrders() async throws(OrderServiceError) -> [Order] {
        switch fetchOrdersResult {
        case .success(let orders): return orders
        case .failure(let error): throw error
        }
    }

    func fetchOrder(id: Int) async throws(OrderServiceError) -> Order {
        switch fetchOrderResult {
        case .success(let order): return order
        case .failure(let error): throw error
        }
    }
}
