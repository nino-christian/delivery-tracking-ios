//
//  ProductServiceClient.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct ProductServiceClient {
    var fetchProduct: (_ id: Int) async throws -> Product = { _ in StubData.products[0] }
}

extension ProductServiceClient: DependencyKey {
    static let liveValue: ProductServiceClient = makeClient(service: ProductService())

    static func makeClient(service: any ProductServiceProtocol) -> ProductServiceClient {
        ProductServiceClient(
            fetchProduct: { id in try await service.fetchProduct(id: id) }
        )
    }
}

extension DependencyValues {
    var productService: ProductServiceClient {
        get { self[ProductServiceClient.self] }
        set { self[ProductServiceClient.self] = newValue }
    }
}
