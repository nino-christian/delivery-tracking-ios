//
//  OrderDetailSkeletonView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

struct OrderDetailSkeletonView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        SkeletonShape(width: 90, height: 11)
                        SkeletonShape(width: 120, height: 20)
                    }
                    Spacer()
                    SkeletonShape(width: 28, height: 28, cornerRadius: 14)
                }
                .padding(.vertical, 4)
            }

            Section("Order") {
                skeletonRow(labelWidth: 55, valueWidth: 70)
                skeletonRow(labelWidth: 55, valueWidth: 30)
            }

            Section("Product") {
                skeletonRow(labelWidth: 40, valueWidth: 150)
                skeletonRow(labelWidth: 95, valueWidth: 80)
                SkeletonShape(width: 130, height: 14)
            }

            Section("Status History") {
                ForEach(0..<3, id: \.self) { _ in
                    HStack {
                        SkeletonShape(width: 80, height: 14)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            SkeletonShape(width: 60, height: 12)
                            SkeletonShape(width: 48, height: 10)
                        }
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func skeletonRow(labelWidth: CGFloat, valueWidth: CGFloat) -> some View {
        HStack {
            SkeletonShape(width: labelWidth, height: 14)
            Spacer()
            SkeletonShape(width: valueWidth, height: 14)
        }
    }
}

#Preview {
    NavigationStack {
        OrderDetailSkeletonView()
            .navigationTitle("Order #1")
    }
}
