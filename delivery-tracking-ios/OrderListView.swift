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
        switch store.ordersStatus {
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
                    Button {
                        store.send(.orderRowTapped(id: order.id))
                    } label: {
                        OrderRow(order: order)
                    }
                    .buttonStyle(.plain)
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

private struct OrderRow: View {
    let order: Order

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(order.product.name)
                    .font(.headline)
                Text("Qty: \(order.quantity)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let status = order.currentStatus {
                    Text(status.status.displayName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(status.status.color, in: RoundedRectangle(cornerRadius: 6))
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        OrderListView(store: Store(initialState: OrderListFeature.State()) {
            OrderListFeature()
        })
    }
}
