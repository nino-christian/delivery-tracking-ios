//
//  AppFeature.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var orderList = OrderListFeature.State()
        var path = StackState<Path.State>()
    }

    @Reducer
    enum Path {
        case orderDetail(OrderDetailFeature)
        case product(ProductFeature)
    }

    enum Action {
        case orderList(OrderListFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.orderList, action: \.orderList) {
            OrderListFeature()
        }

        Reduce { state, action in
            switch action {
            case let .orderList(.delegate(.orderTapped(id: id))):
                guard let order = state.orderList.orders.first(where: { $0.id == id }) else {
                    return .none
                }
                state.path.append(.orderDetail(OrderDetailFeature.State(order: order)))
                return .none

            case let .path(.element(id: _, action: .orderDetail(.delegate(.productTapped(productId: productId))))):
                state.path.append(.product(ProductFeature.State(productId: productId)))
                return .none

            case .orderList, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension AppFeature.Path.State: Equatable {}
