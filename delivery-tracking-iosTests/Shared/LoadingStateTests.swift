//
//  LoadingStateTests.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import XCTest
@testable import delivery_tracking_ios

final class LoadingStateTests: XCTestCase {

    // MARK: - Error
    
    enum MockError: Error, Equatable {
        case generic
    }
    
    // MARK: - isIdle

    func test_isIdle_whenIdle() {
        let state = LoadingState<MockError>.idle
        
        XCTAssertTrue(state.isIdle, "Expected state to be idle")
    }

    func test_isIdle_whenLoading() {
        let state = LoadingState<MockError>.loading
        
        XCTAssertFalse(state.isIdle, "Expected loading state not to be idle")
    }

    func test_isIdle_whenFailure() {
        let state = LoadingState<MockError>.failure(.generic)
        
        XCTAssertFalse(state.isIdle, "Expected failure state not to be idle")
    }

    // MARK: - isLoading

    func test_isLoading_whenLoading() {
        let state  = LoadingState<MockError>.loading
        
        XCTAssertTrue(state.isLoading)
    }

    func test_isLoading_whenIdle() {
        let state = LoadingState<MockError>.idle
        
        XCTAssertFalse(state.isLoading)
    }

    func test_isLoading_whenFailure() {
        let state = LoadingState<MockError>.failure(.generic)
        
        XCTAssertFalse(state.isLoading)
    }

    // MARK: - isFailure

    func test_isFailure_whenFailure() {
        let state = LoadingState<MockError>.failure(.generic)
        
        XCTAssertTrue(state.isFailure)
    }

    func test_isFailure_whenIdle() {
        let state = LoadingState<MockError>.idle
        
        XCTAssertFalse(state.isFailure)
    }
}
