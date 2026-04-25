//
//  ProductSkeletonView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

struct ProductSkeletonView: View {
    var body: some View {
        List {
            Section {
                skeletonRow(labelWidth: 40, valueWidth: 160)
                skeletonRow(labelWidth: 95, valueWidth: 80)
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
        ProductSkeletonView()
            .navigationTitle("Product Detail")
    }
}
