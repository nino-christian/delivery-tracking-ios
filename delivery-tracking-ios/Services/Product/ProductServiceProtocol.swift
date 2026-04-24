//
//  ProductServiceProtocol.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchProduct(id: Int) async throws(ProductServiceError) -> Product
}
