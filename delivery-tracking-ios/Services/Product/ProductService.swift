//
//  ProductService.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

class ProductService {
    func fetchProduct(id: Int) async throws(ProductServiceError) -> Product {
        do {
            try await Task.sleep(for: .seconds(1))
        } catch {
            throw .fetchFailed
        }
        
        guard let product = StubData.product(id: id) else {
            throw .notFound(id: id)
        }
        
        return product
    }
}
