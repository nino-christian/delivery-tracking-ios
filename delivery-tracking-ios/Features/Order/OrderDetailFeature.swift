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
        var order: Order
        var fetchStatus: LoadingState<OrderDetailFeatureError> = .idle
    }

    enum Action: Equatable {
        case onAppear
        case retryFetchTapped
        case fetchOrderResponse(Result<Order, OrderDetailFeatureError>)
        case statusUpdateReceived(OrderStatus)
        case viewProductTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case productTapped(productId: Int)
        }
    }

    enum CancelID: String { case statusSimulation, fetchOrder }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.date) var date
    @Dependency(\.orderService) var orderService

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.fetchStatus.isLoading else { return .none }
                state.fetchStatus = .loading
                return fetchEffect(id: state.order.id)

            case .retryFetchTapped:
                guard !state.fetchStatus.isLoading else { return .none }
                state.fetchStatus = .loading
                return fetchEffect(id: state.order.id)

            case .fetchOrderResponse(.success(let order)):
                state.order = order
                state.fetchStatus = .idle
                guard let current = order.currentStatus?.status,
                      current != .delivered else { return .none }
                return simulationEffect(from: current)

            case .fetchOrderResponse(.failure(let error)):
                state.fetchStatus = .failure(error)
                return .none

            case .statusUpdateReceived(let status):
                state.order.statusHistory.append(
                    OrderStatusEntry(status: status, timestamp: date.now)
                )
                return .none

            case .viewProductTapped:
                return .send(.delegate(.productTapped(productId: state.order.product.id)))

            case .delegate:
                return .none
            }
        }
    }

    private func fetchEffect(id: Int) -> Effect<Action> {
        .run { send in
            do {
                let order = try await orderService.fetchOrder(id)
                await send(.fetchOrderResponse(.success(order)))
            } catch let error as OrderServiceError {
                switch error {
                case .fetchFailed:
                    await send(.fetchOrderResponse(.failure(.fetchFailed)))
                case .notFound(let id):
                    await send(.fetchOrderResponse(.failure(.notFound(id: id))))
                }
            } catch {
                await send(.fetchOrderResponse(.failure(.fetchFailed)))
            }
        }
        .cancellable(id: CancelID.fetchOrder, cancelInFlight: true)
    }

    private func simulationEffect(from currentStatus: OrderStatus) -> Effect<Action> {
        .run { send in
            var status = currentStatus
            while status != .delivered {
                try await clock.sleep(for: .seconds(4))
                let next: OrderStatus = status == .pending ? .inTransit : .delivered
                await send(.statusUpdateReceived(next))
                status = next
            }
        }
        .cancellable(id: CancelID.statusSimulation, cancelInFlight: true)
    }
}
