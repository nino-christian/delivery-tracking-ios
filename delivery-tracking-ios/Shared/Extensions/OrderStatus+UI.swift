//
//  OrderStatus+UI.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import SwiftUI

extension OrderStatus {

    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .inTransit: return "In Transit"
        case .delivered: return "Delivered"
        }
    }

    var color: Color {
        switch self {
        case .pending: return .orange
        case .inTransit: return .yellow
        case .delivered: return .green
        }
    }
}
