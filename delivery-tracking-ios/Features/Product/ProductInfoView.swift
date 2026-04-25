//
//  ProductInfoView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

struct ProductInfoView: View {
    let product: Product

    var body: some View {
        List {
            Section {
                LabeledContent("Name", value: product.name)

                LabeledContent("Manufacturer", value: product.manufacturer)
            }
        }
    }
}

#Preview {
    ProductInfoView(product: StubData.products[0])
}
