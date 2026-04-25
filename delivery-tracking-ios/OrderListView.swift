//
//  OrderListView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import SwiftUI

struct OrderListView: View {
    @Bindable var store: StoreOf<OrderListFeature>

    var body: some View {
        contentView(store: store)
            .navigationTitle("Orders")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

extension OrderListView {
    @ViewBuilder
    func contentView(store: StoreOf<OrderListFeature>) -> some View {
        switch store.fetchStatus {
        case .idle:
            if store.orders.isEmpty {
                VStack(spacing: 12) {
                    Text("No orders yet")
                    Button("Retry") {
                        store.send(.retryButtonTapped)
                    }
                }
            } else {
                List(store.orders) { order in
                    OrderRow(order: order) {
                        store.send(.orderRowTapped(id: order.id))
                    }
                }
            }

        case .loading:
            OrderListSkeletonView()

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
        OrderListView(store: Store(initialState: OrderListFeature.State()) {
            OrderListFeature()
        })
    }
}
