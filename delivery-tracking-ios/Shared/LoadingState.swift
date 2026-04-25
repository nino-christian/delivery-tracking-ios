//
//  LoadingState.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

enum LoadingState<E: Error & Equatable>: Equatable {
    case idle
    case loading
    case failure(E)
    
    var isIdle: Bool {
        if case .idle = self { return true } else { return false }
    }
    
    var isLoading: Bool {
        if case .loading = self { return true } else { return false }
    }
    
    var isFailure: Bool {
        if case .failure = self { return true } else { return false }
    }
}
