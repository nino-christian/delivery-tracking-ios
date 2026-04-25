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

    // MARK: - fetchOrders via client

    func test_fetchOrders_failureThroughClient() async {
        let client = OrderServiceClient(
            fetchOrders: { throw OrderServiceError.fetchFailed },
            fetchOrder: { _ in throw OrderServiceError.fetchFailed }
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

    // MARK: - fetchOrder via client

    func test_fetchOrder_failureThroughClient() async {
        let client = OrderServiceClient(
            fetchOrders: { StubData.orders },
            fetchOrder: { _ in throw OrderServiceError.fetchFailed }
        )

        do {
            _ = try await client.fetchOrder(1)
            XCTFail("Expected fetchFailed error to be thrown")
        } catch let error as OrderServiceError {
            XCTAssertEqual(error, .fetchFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchOrder_notFoundThroughClient() async {
        let client = OrderServiceClient(
            fetchOrders: { StubData.orders },
            fetchOrder: { id in throw OrderServiceError.notFound(id: id) }
        )

        do {
            _ = try await client.fetchOrder(999)
            XCTFail("Expected notFound error to be thrown")
        } catch let error as OrderServiceError {
            XCTAssertEqual(error, .notFound(id: 999))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
