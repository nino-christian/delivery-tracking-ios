//
//  OrderListSkeletonView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

struct OrderListSkeletonView: View {
    var body: some View {
        List {
            ForEach(0..<6, id: \.self) { _ in
                OrderRowSkeleton()
            }
        }
        .allowsHitTesting(false)
    }
}

private struct OrderRowSkeleton: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                SkeletonShape(width: 160, height: 15)
                SkeletonShape(width: 70, height: 12)
                SkeletonShape(width: 90, height: 10, cornerRadius: 5)
            }
            Spacer()
            SkeletonShape(width: 10, height: 15, cornerRadius: 3)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    OrderListSkeletonView()
}
