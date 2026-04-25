//
//  delivery_tracking_iosApp.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import SwiftUI

@main
struct delivery_tracking_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: OrderFeature.State()) {
                OrderFeature()
            })
        }
    }
}
