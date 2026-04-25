//
//  ContentView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @Bindable var store: StoreOf<OrderFeature>

    var body: some View {
        contentView(store: store)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension ContentView {
    @ViewBuilder
    func contentView(store: StoreOf<OrderFeature>) -> some View {
        switch store.ordersStatus {
        case .idle:
            if store.orders.isEmpty {
                VStack(spacing: 12) {
                    Text("No orders")
                    Button("Retry") {
                        store.send(.retryButtonTapped)
                    }
                }
            } else {
                List(store.orders, id: \.id) { order in
                    Text("Order #\(order.id)")
                }
            }
        case .loading:
            ProgressView()
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
    ContentView(store: Store(initialState: OrderFeature.State()) {
        OrderFeature()
    })
}
