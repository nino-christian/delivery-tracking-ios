//
//  OrderDetailFeatureTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import XCTest
@testable import delivery_tracking_ios

@MainActor
final class OrderDetailFeatureTests: XCTestCase {

    // MARK: - onAppear / fetch

    func test_onAppear_setsLoadingThenSuccess_andStartsSimulation() async {
        let order = StubData.orders[0] // inTransit
        let fixedDate = Date(timeIntervalSince1970: 1000)
        let clock = TestClock()
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order)
        ) {
            OrderDetailFeature()
        } withDependencies: {
            $0.orderService.fetchOrder = { _ in order }
            $0.continuousClock = clock
            $0.date = .constant(fixedDate)
        }

        await store.send(.onAppear) { $0.fetchStatus = .loading }
        await store.receive(.fetchOrderResponse(.success(order))) {
            $0.order = order
            $0.fetchStatus = .idle
        }

        await clock.advance(by: .seconds(4))
        await store.receive(.statusUpdateReceived(.delivered)) {
            $0.order.statusHistory.append(OrderStatusEntry(status: .delivered, timestamp: fixedDate))
        }
    }

    func test_onAppear_setsLoadingThenFailure() async {
        let order = StubData.orders[0]
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order)
        ) {
            OrderDetailFeature()
        } withDependencies: {
            $0.orderService.fetchOrder = { _ in throw OrderServiceError.fetchFailed }
        }

        await store.send(.onAppear) { $0.fetchStatus = .loading }
        await store.receive(.fetchOrderResponse(.failure(.fetchFailed))) {
            $0.fetchStatus = .failure(.fetchFailed)
        }
    }

    func test_onAppear_isIgnored_whenLoading() async {
        let order = StubData.orders[0]
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order)
        ) {
            OrderDetailFeature()
        } withDependencies: {
            $0.orderService.fetchOrder = { _ in order }
            $0.continuousClock = TestClock()
            $0.date = .constant(Date(timeIntervalSince1970: 1000))
        }
        store.exhaustivity = .off

        await store.send(.onAppear) { $0.fetchStatus = .loading }
        await store.send(.onAppear)
    }

    // MARK: - retryFetchTapped

    func test_retryFetchTapped_setsLoadingThenSuccess() async {
        let order = StubData.orders[0]
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order, fetchStatus: .failure(.fetchFailed))
        ) {
            OrderDetailFeature()
        } withDependencies: {
            $0.orderService.fetchOrder = { _ in order }
            $0.continuousClock = TestClock()
            $0.date = .constant(Date(timeIntervalSince1970: 1000))
        }
        store.exhaustivity = .off

        await store.send(.retryFetchTapped) { $0.fetchStatus = .loading }
        await store.receive(.fetchOrderResponse(.success(order))) {
            $0.order = order
            $0.fetchStatus = .idle
        }
    }

    func test_retryFetchTapped_setsFailure_onNotFound() async {
        let order = StubData.orders[0]
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order, fetchStatus: .failure(.fetchFailed))
        ) {
            OrderDetailFeature()
        } withDependencies: {
            $0.orderService.fetchOrder = { id in throw OrderServiceError.notFound(id: id) }
        }

        await store.send(.retryFetchTapped) { $0.fetchStatus = .loading }
        await store.receive(.fetchOrderResponse(.failure(.notFound(id: order.id)))) {
            $0.fetchStatus = .failure(.notFound(id: order.id))
        }
    }

    // MARK: - onDisappear

    func test_onDisappear_cancelsBothEffects() async {
        let order = StubData.orders[2] // pending
        let clock = TestClock()
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order)
        ) {
            OrderDetailFeature()
        } withDependencies: {
            $0.orderService.fetchOrder = { _ in order }
            $0.continuousClock = clock
            $0.date = .constant(Date(timeIntervalSince1970: 1000))
        }
        store.exhaustivity = .off

        await store.send(.onAppear)
        await store.send(.onDisappear)
        await clock.advance(by: .seconds(30))
    }

    // MARK: - statusUpdateReceived

    func test_statusUpdateReceived_appendsEntryToHistory() async {
        let order = StubData.orders[0]
        let fixedDate = Date(timeIntervalSince1970: 1000)
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order)
        ) {
            OrderDetailFeature()
        } withDependencies: {
            $0.date = .constant(fixedDate)
        }

        await store.send(.statusUpdateReceived(.delivered)) {
            $0.order.statusHistory.append(OrderStatusEntry(status: .delivered, timestamp: fixedDate))
        }
    }

    // MARK: - viewProductTapped

    func test_viewProductTapped_emitsDelegate() async {
        let order = StubData.orders[0]
        let store = TestStore(
            initialState: OrderDetailFeature.State(order: order)
        ) {
            OrderDetailFeature()
        }

        await store.send(.viewProductTapped)
        await store.receive(.delegate(.productTapped(productId: order.product.id)))
    }
}
