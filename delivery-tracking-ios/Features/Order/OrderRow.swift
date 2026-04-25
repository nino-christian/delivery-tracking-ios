//
//  OrderRow.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

struct OrderRow: View {
    let order: Order
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
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
        .buttonStyle(.plain)
    }
}

#Preview {
    List {
        OrderRow(order: StubData.orders[0]) {}
        OrderRow(order: StubData.orders[1]) {}
    }
}
