//
//  CurrentStatusView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

struct CurrentStatusView: View {
    let entry: OrderStatusEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Status")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(entry.status.displayName)
                    .font(.title3.bold())
                    .foregroundStyle(entry.status.color)
            }
            Spacer()
            if entry.status == .delivered {
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

#Preview {
    List {
        CurrentStatusView(entry: OrderStatusEntry(status: .pending, timestamp: .now))
        CurrentStatusView(entry: OrderStatusEntry(status: .inTransit, timestamp: .now))
        CurrentStatusView(entry: OrderStatusEntry(status: .delivered, timestamp: .now))
    }
}
