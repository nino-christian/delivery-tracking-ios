import Foundation

enum OrderStatus: String, Equatable, Codable, CaseIterable {
    case pending = "PENDING"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"
}

struct OrderStatusEntry: Equatable, Codable {
    var status: OrderStatus
    var timestamp: Date
}
