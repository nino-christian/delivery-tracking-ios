//
//  ProductView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import SwiftUI

struct ProductView: View {
    @Bindable var store: StoreOf<ProductFeature>

    var body: some View {
        productContent(store: store)
            .navigationTitle("Product Detail")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                store.send(.onAppear)
            }
    }
}

extension ProductView {
    @ViewBuilder
    func productContent(store: StoreOf<ProductFeature>) -> some View {
        switch store.fetchStatus {
        case .idle:
            if let product = store.product {
                ProductInfoView(product: product)
            } else {
                ProductSkeletonView()
            }

        case .loading:
            ProductSkeletonView()

        case .failure(let error):
            VStack(spacing: 12) {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)

                Button("Retry") {
                    store.send(.retryButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductView(store: Store(
            initialState: ProductFeature.State(productId: 1)
        ) {
            ProductFeature()
        })
    }
}
