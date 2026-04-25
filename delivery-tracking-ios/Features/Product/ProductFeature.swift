//
//  ProductFeature.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ProductFeature {

    @ObservableState
    struct State: Equatable {
        let productId: Int
        var product: Product? = nil
        var productState: LoadingState<ProductFeatureError> = .idle
    }

    enum Action: Equatable {
        case onAppear
        case retryButtonTapped
        case fetchProductResponse(Result<Product, ProductFeatureError>)
    }

    enum CancelID: String {
        case fetchProduct
    }

    @Dependency(\.productService) var productService

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if case .loading = state.productState { return .none }
                state.productState = .loading
                return fetchEffect(id: state.productId)

            case .retryButtonTapped:
                guard !state.productState.isLoading else { return .none }
                state.productState = .loading
                return fetchEffect(id: state.productId)

            case .fetchProductResponse(.success(let product)):
                state.product = product
                state.productState = .idle
                return .none

            case .fetchProductResponse(.failure(let error)):
                state.product = nil
                state.productState = .failure(error)
                return .none
            }
        }
    }

    private func fetchEffect(id: Int) -> Effect<Action> {
        .run { send in
            do {
                let product = try await productService.fetchProduct(id)
                await send(.fetchProductResponse(.success(product)))
            } catch let error as ProductServiceError {
                switch error {
                case .fetchFailed:
                    await send(.fetchProductResponse(.failure(.fetchFailed)))
                case .notFound(let id):
                    await send(.fetchProductResponse(.failure(.notFound(id: id))))
                }
            } catch {
                await send(.fetchProductResponse(.failure(.fetchFailed)))
            }
        }
        .cancellable(id: CancelID.fetchProduct, cancelInFlight: true)
    }
}
