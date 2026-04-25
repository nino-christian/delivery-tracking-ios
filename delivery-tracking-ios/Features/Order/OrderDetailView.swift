//
//  OrderDetailView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import SwiftUI

struct OrderDetailView: View {
    @Bindable var store: StoreOf<OrderDetailFeature>

    var body: some View {
        detailContent(store: store)
            .navigationTitle("Order #\(store.order.id)")
            .onAppear { store.send(.onAppear) }
    }
}

extension OrderDetailView {
    @ViewBuilder
    func detailContent(store: StoreOf<OrderDetailFeature>) -> some View {
        switch store.fetchStatus {
        case .loading:
            OrderDetailSkeletonView()

        case .failure(let error):
            VStack(spacing: 12) {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)

                Button("Retry") {
                    store.send(.retryFetchTapped)
                }
            }
            .padding()

        case .idle:
            List {
                if let current = store.order.currentStatus {
                    Section {
                        CurrentStatusView(entry: current)
                    }
                }

                Section("Order") {
                    LabeledContent("Order ID", value: "#\(store.order.id)")

                    LabeledContent("Quantity", value: "\(store.order.quantity)")
                }

                Section("Product") {
                    LabeledContent("Name", value: store.order.product.name)

                    LabeledContent("Manufacturer", value: store.order.product.manufacturer)

                    Button("View Product Detail") {
                        store.send(.viewProductTapped)
                    }
                }

                Section("Status History") {
                    ForEach(store.order.statusHistory, id: \.timestamp) { entry in
                        StatusHistoryRow(entry: entry)
                    }
                }
            }
            .animation(.default, value: store.order.statusHistory)
        }
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(store: Store(
            initialState: OrderDetailFeature.State(order: StubData.orders[0])
        ) {
            OrderDetailFeature()
        })
    }
}
