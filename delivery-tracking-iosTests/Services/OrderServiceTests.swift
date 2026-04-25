//
//  OrderServiceTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import XCTest
@testable import delivery_tracking_ios

@MainActor
final class OrderServiceTests: XCTestCase {

    private func makeSUT() -> (client: OrderServiceClient, mock: MockOrderService) {
        let mock = MockOrderService()
        let client = OrderServiceClient.makeClient(service: mock)
        return (client, mock)
    }

    // MARK: - fetchOrders

    func test_fetchOrders_returnsAllOrders() async throws {
        let (client, _) = makeSUT()

        let orders = try await client.fetchOrders()

        XCTAssertEqual(orders.count, StubData.orders.count)
    }

    func test_fetchOrders_returnsCorrectOrderIds() async throws {
        let (client, _) = makeSUT()

        let orders = try await client.fetchOrders()

        XCTAssertEqual(orders.map { $0.id }, StubData.orders.map { $0.id })
    }

    func test_fetchOrders_eachOrderHasAtLeastOneStatusEntry() async throws {
        let (client, _) = makeSUT()

        let orders = try await client.fetchOrders()

        for order in orders {
            XCTAssertFalse(order.statusHistory.isEmpty, "Order \(order.id) has no status history")
        }
    }

    func test_fetchOrders_throwsFetchFailed() async {
        let (client, mock) = makeSUT()
        mock.fetchOrdersResult = .failure(.fetchFailed)

        do {
            _ = try await client.fetchOrders()
            XCTFail("Expected fetchFailed error")
        } catch let error as OrderServiceError {
            XCTAssertEqual(error, .fetchFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - fetchOrder

    func test_fetchOrder_returnsCorrectOrder() async throws {
        let (client, mock) = makeSUT()
        let expected = StubData.orders[0]
        mock.fetchOrderResult = .success(expected)

        let order = try await client.fetchOrder(expected.id)

        XCTAssertEqual(order.id, expected.id)
    }

    func test_fetchOrder_throwsFetchFailed() async {
        let (client, mock) = makeSUT()
        mock.fetchOrderResult = .failure(.fetchFailed)

        do {
            _ = try await client.fetchOrder(1)
            XCTFail("Expected fetchFailed error")
        } catch let error as OrderServiceError {
            XCTAssertEqual(error, .fetchFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchOrder_throwsNotFound() async {
        let (client, mock) = makeSUT()
        mock.fetchOrderResult = .failure(.notFound(id: 999))

        do {
            _ = try await client.fetchOrder(999)
            XCTFail("Expected notFound error")
        } catch let error as OrderServiceError {
            XCTAssertEqual(error, .notFound(id: 999))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
