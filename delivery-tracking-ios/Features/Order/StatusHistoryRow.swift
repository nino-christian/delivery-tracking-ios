//
//  StatusHistoryRow.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

struct StatusHistoryRow: View {
    let entry: OrderStatusEntry

    var body: some View {
        HStack {
            Text(entry.status.displayName)
                .foregroundStyle(entry.status.color)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(entry.timestamp, formatter: .auTime)
                    .font(.caption)

                Text(entry.timestamp, formatter: .auDate)
                    .font(.caption2)
            }
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        StatusHistoryRow(entry: OrderStatusEntry(status: .pending, timestamp: .now))

        StatusHistoryRow(entry: OrderStatusEntry(status: .inTransit, timestamp: .now))

        StatusHistoryRow(entry: OrderStatusEntry(status: .delivered, timestamp: .now))
    }
}
