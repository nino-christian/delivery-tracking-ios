//
//  OrderListFeature.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct OrderListFeature {

    @ObservableState
    struct State: Equatable {
        var orders: [Order] = []
        var ordersStatus: LoadingState<OrderListFeatureError> = .idle
    }

    enum Action: Equatable {
        case onAppear
        case retryButtonTapped
        case orderRowTapped(id: Int)
        case fetchOrdersResponse(Result<[Order], OrderListFeatureError>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case orderTapped(id: Int)
        }
    }

    @Dependency(\.orderService) var orderService

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if case .loading = state.ordersStatus { return .none }
                state.ordersStatus = .loading
                return fetchEffect

            case .retryButtonTapped:
                guard !state.ordersStatus.isLoading else { return .none }
                state.ordersStatus = .loading
                return fetchEffect

            case .orderRowTapped(let id):
                return .send(.delegate(.orderTapped(id: id)))

            case .fetchOrdersResponse(.success(let orders)):
                state.orders = orders
                state.ordersStatus = .idle
                return .none

            case .fetchOrdersResponse(.failure(let error)):
                state.ordersStatus = .failure(error)
                return .none

            case .delegate:
                return .none
            }
        }
    }

    private var fetchEffect: Effect<Action> {
        .run { send in
            do {
                let orders = try await orderService.fetchOrders()
                await send(.fetchOrdersResponse(.success(orders)))
            } catch {
                await send(.fetchOrdersResponse(.failure(.fetchFailed)))
            }
        }
    }
}
