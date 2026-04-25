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

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        f.locale = Locale(identifier: "en_AU")
        return f
    }()

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yy"
        f.locale = Locale(identifier: "en_AU")
        return f
    }()

    var body: some View {
        detailContent(store: store)
            .navigationTitle("Order #\(store.order.id)")
            .onAppear { store.send(.onAppear) }
            .onDisappear { store.send(.onDisappear) }
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
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Status")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(current.status.displayName)
                                    .font(.title3.bold())
                                    .foregroundStyle(current.status.color)
                            }
                            Spacer()
                            if current.status == .delivered {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.green)
                            } else {
                                ProgressView()
                            }
                        }
                        .padding(.vertical, 4)
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
                        HStack {
                            Text(entry.status.displayName)
                                .foregroundStyle(entry.status.color)

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(entry.timestamp, formatter: Self.timeFormatter)
                                    .font(.caption)
                                Text(entry.timestamp, formatter: Self.dateFormatter)
                                    .font(.caption2)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
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
