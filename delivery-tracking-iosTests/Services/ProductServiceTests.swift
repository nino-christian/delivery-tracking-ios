//
//  ProductServiceTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import XCTest
@testable import delivery_tracking_ios

final class ProductServiceTests: XCTestCase {

    private var sut: ProductService!

    override func setUp() {
        super.setUp()
        sut = ProductService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Success

    func test_fetchProduct_returnsCorrectProduct() async throws {
        let product = try await sut.fetchProduct(id: 1)

        XCTAssertEqual(product.id, 1)
    }

    func test_fetchProduct_returnsCorrectName() async throws {
        let product = try await sut.fetchProduct(id: 1)

        XCTAssertEqual(product.name, StubData.products[0].name)
    }

    // MARK: - Failure

    func test_fetchProduct_throwsNotFound_forInvalidId() async {
        do {
            _ = try await sut.fetchProduct(id: 999)
            XCTFail("Expected notFound error to be thrown")
        } catch let error as ProductServiceError {
            XCTAssertEqual(error, .notFound(id: 999))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchProduct_failureThroughClient() async {
        let client = ProductServiceClient(
            fetchProduct: { _ in throw ProductServiceError.fetchFailed }
        )

        do {
            _ = try await client.fetchProduct(1)
            XCTFail("Expected fetchFailed error to be thrown")
        } catch let error as ProductServiceError {
            XCTAssertEqual(error, .fetchFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
