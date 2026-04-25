//
//  ProductServiceTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import XCTest
@testable import delivery_tracking_ios

@MainActor
final class ProductServiceTests: XCTestCase {

    private func makeSUT() -> (client: ProductServiceClient, mock: MockProductService) {
        let mock = MockProductService()
        let client = ProductServiceClient.makeClient(service: mock)
        return (client, mock)
    }

    // MARK: - fetchProduct

    func test_fetchProduct_returnsCorrectProduct() async throws {
        let (client, mock) = makeSUT()
        mock.fetchProductResult = .success(StubData.products[0])

        let product = try await client.fetchProduct(1)

        XCTAssertEqual(product.id, StubData.products[0].id)
    }

    func test_fetchProduct_returnsCorrectName() async throws {
        let (client, mock) = makeSUT()
        mock.fetchProductResult = .success(StubData.products[0])

        let product = try await client.fetchProduct(1)

        XCTAssertEqual(product.name, StubData.products[0].name)
    }

    func test_fetchProduct_throwsNotFound_forInvalidId() async {
        let (client, mock) = makeSUT()
        mock.fetchProductResult = .failure(.notFound(id: 999))

        do {
            _ = try await client.fetchProduct(999)
            XCTFail("Expected notFound error")
        } catch let error as ProductServiceError {
            XCTAssertEqual(error, .notFound(id: 999))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchProduct_throwsFetchFailed() async {
        let (client, mock) = makeSUT()
        mock.fetchProductResult = .failure(.fetchFailed)

        do {
            _ = try await client.fetchProduct(1)
            XCTFail("Expected fetchFailed error")
        } catch let error as ProductServiceError {
            XCTAssertEqual(error, .fetchFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
