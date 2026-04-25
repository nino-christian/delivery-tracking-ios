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
        let store = TestStore(initialState: OrderFeature.State()) {
            OrderFeature()
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
        let store = TestStore(initialState: OrderFeature.State()) {
            OrderFeature()
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
            initialState: OrderFeature.State(ordersStatus: .failure(.fetchFailed))
        ) {
            OrderFeature()
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
        let store = TestStore(initialState: OrderFeature.State()) {
            OrderFeature()
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
        let store = TestStore(initialState: OrderFeature.State()) {
            OrderFeature()
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
            initialState: OrderFeature.State(ordersStatus: .failure(.fetchFailed))
        ) {
            OrderFeature()
        } withDependencies: {
            $0.orderService.fetchOrders = { throw OrderServiceError.fetchFailed }
        }

        await store.send(.retryButtonTapped) { $0.ordersStatus = .loading }
        await store.receive(.fetchOrdersResponse(.failure(.fetchFailed))) {
            $0.ordersStatus = .failure(.fetchFailed)
        }
    }
}
