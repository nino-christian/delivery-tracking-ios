//
//  ProductFeatureTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import XCTest
@testable import delivery_tracking_ios

@MainActor
final class ProductFeatureTests: XCTestCase {

    // MARK: - Success

    func test_fetchProduct_setsLoadingThenSuccess() async {
        let expectedProduct = StubData.products[0]
        let store = TestStore(initialState: ProductFeature.State()) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in expectedProduct }
        }

        await store.send(.fetchProduct(id: expectedProduct.id)) { $0.productState = .loading }
        await store.receive(.fetchProductResponse(.success(expectedProduct))) {
            $0.product = expectedProduct
            $0.productState = .idle
        }
    }

    func test_fetchProduct_isIgnored_whenAlreadyLoading() async {
        let store = TestStore(initialState: ProductFeature.State()) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in StubData.products[0] }
        }
        store.exhaustivity = .off

        await store.send(.fetchProduct(id: 1)) { $0.productState = .loading }

        // Guard blocks — already in flight
        await store.send(.fetchProduct(id: 1))
    }

    // MARK: - Failure

    func test_fetchProduct_setsFailureState_onFetchFailed() async {
        let store = TestStore(initialState: ProductFeature.State()) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in throw ProductServiceError.fetchFailed }
        }

        await store.send(.fetchProduct(id: 1)) { $0.productState = .loading }
        await store.receive(.fetchProductResponse(.failure(.fetchFailed))) {
            $0.productState = .failure(.fetchFailed)
        }
    }

    func test_fetchProduct_setsFailureState_onNotFound() async {
        let store = TestStore(initialState: ProductFeature.State()) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { id in throw ProductServiceError.notFound(id: id) }
        }

        await store.send(.fetchProduct(id: 999)) { $0.productState = .loading }
        await store.receive(.fetchProductResponse(.failure(.notFound(id: 999)))) {
            $0.productState = .failure(.notFound(id: 999))
        }
    }
}
