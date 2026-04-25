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

    // MARK: - onAppear

    func test_onAppear_setsLoadingThenSuccess() async {
        let expectedProduct = StubData.products[0]
        let store = TestStore(
            initialState: ProductFeature.State(productId: expectedProduct.id)
        ) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in expectedProduct }
        }

        await store.send(.onAppear) { $0.productState = .loading }
        await store.receive(.fetchProductResponse(.success(expectedProduct))) {
            $0.product = expectedProduct
            $0.productState = .idle
        }
    }

    func test_onAppear_isIgnored_whenLoading() async {
        let store = TestStore(
            initialState: ProductFeature.State(productId: 1)
        ) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in StubData.products[0] }
        }
        store.exhaustivity = .off

        await store.send(.onAppear) { $0.productState = .loading }

        // Guard blocks — already in flight
        await store.send(.onAppear)
    }

    // MARK: - retryButtonTapped

    func test_retryButtonTapped_setsLoadingThenSuccess() async {
        let expectedProduct = StubData.products[0]
        let store = TestStore(
            initialState: ProductFeature.State(productId: expectedProduct.id, productState: .failure(.fetchFailed))
        ) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in expectedProduct }
        }

        await store.send(.retryButtonTapped) { $0.productState = .loading }
        await store.receive(.fetchProductResponse(.success(expectedProduct))) {
            $0.product = expectedProduct
            $0.productState = .idle
        }
    }

    func test_retryButtonTapped_isIgnored_whenLoading() async {
        let store = TestStore(
            initialState: ProductFeature.State(productId: 1)
        ) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in StubData.products[0] }
        }
        store.exhaustivity = .off

        await store.send(.onAppear) { $0.productState = .loading }

        // Guard blocks — already in flight
        await store.send(.retryButtonTapped)
    }

    // MARK: - Failure

    func test_onAppear_setsFailureState_onFetchFailed() async {
        let store = TestStore(
            initialState: ProductFeature.State(productId: 1)
        ) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { _ in throw ProductServiceError.fetchFailed }
        }

        await store.send(.onAppear) { $0.productState = .loading }
        await store.receive(.fetchProductResponse(.failure(.fetchFailed))) {
            $0.productState = .failure(.fetchFailed)
        }
    }

    func test_onAppear_setsFailureState_onNotFound() async {
        let store = TestStore(
            initialState: ProductFeature.State(productId: 999)
        ) {
            ProductFeature()
        } withDependencies: {
            $0.productService.fetchProduct = { id in throw ProductServiceError.notFound(id: id) }
        }

        await store.send(.onAppear) { $0.productState = .loading }
        await store.receive(.fetchProductResponse(.failure(.notFound(id: 999)))) {
            $0.productState = .failure(.notFound(id: 999))
        }
    }
}
