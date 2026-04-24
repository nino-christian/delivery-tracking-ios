//
//  OrderServiceClient.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct OrderServiceClient {
    var fetchOrders: () async throws -> [Order] = { [] }
}

extension OrderServiceClient: DependencyKey {
    static let liveValue: OrderServiceClient = makeClient(service: OrderService())

    static func makeClient(service: any OrderServiceProtocol) -> OrderServiceClient {
        OrderServiceClient(
            fetchOrders: { try await service.fetchOrders() }
        )
    }
}

extension DependencyValues {
    var orderService: OrderServiceClient {
        get { self[OrderServiceClient.self] }
        set { self[OrderServiceClient.self] = newValue }
    }
}
