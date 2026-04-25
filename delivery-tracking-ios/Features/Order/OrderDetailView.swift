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
        List {
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
        .navigationTitle("Order #\(store.order.id)")
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
