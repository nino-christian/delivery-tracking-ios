//
//  AppView.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            OrderListView(store: store.scope(state: \.orderList, action: \.orderList))
        } destination: { pathStore in
            switch pathStore.case {
            case .orderDetail(let detailStore):
                OrderDetailView(store: detailStore)
            case .product(let productStore):
                ProductView(store: productStore)
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
