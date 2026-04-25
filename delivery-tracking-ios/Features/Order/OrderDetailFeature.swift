//
//  OrderDetailFeature.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct OrderDetailFeature {

    @ObservableState
    struct State: Equatable {
        let order: Order
    }

    enum Action: Equatable {
        case viewProductTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case productTapped(productId: Int)
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewProductTapped:
                return .send(.delegate(.productTapped(productId: state.order.product.id)))

            case .delegate:
                return .none
            }
        }
    }
}
