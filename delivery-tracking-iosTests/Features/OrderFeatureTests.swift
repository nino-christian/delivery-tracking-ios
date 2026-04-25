//
//  OrderFeatureTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import XCTest
@testable import delivery_tracking_ios

@MainActor
final class OrderFeatureTests: XCTestCase {

    // MARK: - onAppear

    func test_onAppear_setsLoadingThenSuccess() async {
        let store = TestStore(initialState: OrderListFeature.State()) {
            OrderListFeature()
        } withDependencies: {
            $0.orderService.fetchOrders = { StubData.orders }
        }

        await store.send(.onAppear) { $0.ordersStatus = .loading }
        await store.receive(.fetchOrdersResponse(.success(StubData.orders))) {
            $0.orders = StubData.orders
            $0.ordersStatus = .idle
        }
    }

    func test_onAppear_isIgnored_whenLoading() async {
        let store = TestStore(initialState: OrderListFeature.State()) {
            OrderListFeature()
        } withDependencies: {
            $0.orderService.fetchOrders = { StubData.orders }
        }
        store.exhaustivity = .off

        await store.send(.onAppear) { $0.ordersStatus = .loading }

        // Guard blocks — already in flight
        await store.send(.onAppear)
    }

    // MARK: - retryButtonTapped

    func test_retryButtonTapped_setsLoadingThenSuccess() async {
        let store = TestStore(
            initialState: OrderListFeature.State(ordersStatus: .failure(.fetchFailed))
        ) {
            OrderListFeature()
        } withDependencies: {
            $0.orderService.fetchOrders = { StubData.orders }
        }

        await store.send(.retryButtonTapped) { $0.ordersStatus = .loading }
        await store.receive(.fetchOrdersResponse(.success(StubData.orders))) {
            $0.orders = StubData.orders
            $0.ordersStatus = .idle
        }
    }

    func test_retryButtonTapped_isIgnored_whenLoading() async {
        let store = TestStore(initialState: OrderListFeature.State()) {
            OrderListFeature()
        } withDependencies: {
            $0.orderService.fetchOrders = { StubData.orders }
        }
        store.exhaustivity = .off

        await store.send(.onAppear) { $0.ordersStatus = .loading }

        // Guard blocks — already in flight
        await store.send(.retryButtonTapped)
    }

    // MARK: - Failure

    func test_onAppear_setsFailureState() async {
        let store = TestStore(initialState: OrderListFeature.State()) {
            OrderListFeature()
        } withDependencies: {
            $0.orderService.fetchOrders = { throw OrderServiceError.fetchFailed }
        }

        await store.send(.onAppear) { $0.ordersStatus = .loading }
        await store.receive(.fetchOrdersResponse(.failure(.fetchFailed))) {
            $0.ordersStatus = .failure(.fetchFailed)
        }
    }

    func test_retryButtonTapped_setsFailureState() async {
        let store = TestStore(
            initialState: OrderListFeature.State(ordersStatus: .failure(.fetchFailed))
        ) {
            OrderListFeature()
        } withDependencies: {
            $0.orderService.fetchOrders = { throw OrderServiceError.fetchFailed }
        }

        await store.send(.retryButtonTapped) { $0.ordersStatus = .loading }
        await store.receive(.fetchOrdersResponse(.failure(.fetchFailed))) {
            $0.ordersStatus = .failure(.fetchFailed)
        }
    }

    // MARK: - Navigation delegate

    func test_orderRowTapped_emitsDelegate() async {
        let order = StubData.orders[0]
        let store = TestStore(
            initialState: OrderListFeature.State(orders: StubData.orders, ordersStatus: .idle)
        ) {
            OrderListFeature()
        }

        await store.send(.orderRowTapped(id: order.id))
        await store.receive(.delegate(.orderTapped(id: order.id)))
    }
}
