//
//  MockProductService.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

@testable import delivery_tracking_ios

final class MockProductService: ProductServiceProtocol {
    var fetchProductResult: Result<Product, ProductServiceError> = .success(StubData.products[0])

    func fetchProduct(id: Int) async throws(ProductServiceError) -> Product {
        switch fetchProductResult {
        case .success(let product): return product
        case .failure(let error): throw error
        }
    }
}
