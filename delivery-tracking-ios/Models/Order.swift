import Foundation

struct Order: Equatable, Identifiable, Codable {
    let id: Int
    var product: Product
    var quantity: Int
    var statusHistory: [OrderStatusEntry]

    var currentStatus: OrderStatusEntry? {
        statusHistory.last
    }
}
