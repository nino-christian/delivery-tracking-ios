//
//  OrderServiceTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import XCTest
@testable import delivery_tracking_ios

final class OrderServiceTests: XCTestCase {

    private var sut: OrderService!

    override func setUp() {
        super.setUp()
        sut = OrderService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Success

    func test_fetchOrders_returnsAllOrders() async throws {
        let orders = try await sut.fetchOrders()

        XCTAssertEqual(orders.count, StubData.orders.count)
    }

    func test_fetchOrders_returnsCorrectOrderIds() async throws {
        let orders = try await sut.fetchOrders()
        let ids = orders.map { $0.id }
        let expectedIds = StubData.orders.map { $0.id }

        XCTAssertEqual(ids, expectedIds)
    }

    func test_fetchOrders_eachOrderHasAtLeastOneStatusEntry() async throws {
        let orders = try await sut.fetchOrders()

        for order in orders {
            XCTAssertFalse(order.statusHistory.isEmpty, "Order \(order.id) has no status history")
        }
    }

    // MARK: - Failure

    func test_fetchOrders_failureThroughClient() async {
        let client = OrderServiceClient(
            fetchOrders: { throw OrderServiceError.fetchFailed }
        )

        do {
            _ = try await client.fetchOrders()
            XCTFail("Expected fetchFailed error to be thrown")
        } catch let error as OrderServiceError {
            XCTAssertEqual(error, .fetchFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
