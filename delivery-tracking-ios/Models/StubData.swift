import Foundation

enum StubData {
    static let products: [Product] = [
        Product(id: 1, name: "Wireless Headphones", manufacturer: "Sony"),
        Product(id: 2, name: "Mechanical Keyboard", manufacturer: "Keychron"),
        Product(id: 3, name: "USB-C Hub", manufacturer: "Anker"),
        Product(id: 4, name: "27\" 4K Monitor", manufacturer: "LG"),
        Product(id: 5, name: "Webcam HD Pro", manufacturer: "Logitech"),
    ]

    static let orders: [Order] = [
        Order(
            id: 1,
            product: products[0],
            quantity: 1,
            statusHistory: [
                OrderStatusEntry(status: .pending, timestamp: Date(timeIntervalSinceNow: -172800)),
                OrderStatusEntry(status: .inTransit, timestamp: Date(timeIntervalSinceNow: -86400)),
            ]
        ),
        Order(
            id: 2,
            product: products[1],
            quantity: 2,
            statusHistory: [
                OrderStatusEntry(status: .pending, timestamp: Date(timeIntervalSinceNow: -259200)),
                OrderStatusEntry(status: .inTransit, timestamp: Date(timeIntervalSinceNow: -172800)),
                OrderStatusEntry(status: .delivered, timestamp: Date(timeIntervalSinceNow: -43200)),
            ]
        ),
        Order(
            id: 3,
            product: products[2],
            quantity: 3,
            statusHistory: [
                OrderStatusEntry(status: .pending, timestamp: Date(timeIntervalSinceNow: -3600)),
            ]
        ),
        Order(
            id: 4,
            product: products[3],
            quantity: 1,
            statusHistory: [
                OrderStatusEntry(status: .pending, timestamp: Date(timeIntervalSinceNow: -432000)),
                OrderStatusEntry(status: .inTransit, timestamp: Date(timeIntervalSinceNow: -345600)),
                OrderStatusEntry(status: .delivered, timestamp: Date(timeIntervalSinceNow: -259200)),
            ]
        ),
        Order(
            id: 5,
            product: products[4],
            quantity: 1,
            statusHistory: [
                OrderStatusEntry(status: .pending, timestamp: Date(timeIntervalSinceNow: -86400)),
                OrderStatusEntry(status: .inTransit, timestamp: Date(timeIntervalSinceNow: -21600)),
            ]
        ),
        Order(
            id: 6,
            product: products[0],
            quantity: 2,
            statusHistory: [
                OrderStatusEntry(status: .pending, timestamp: Date(timeIntervalSinceNow: -518400)),
                OrderStatusEntry(status: .inTransit, timestamp: Date(timeIntervalSinceNow: -432000)),
                OrderStatusEntry(status: .delivered, timestamp: Date(timeIntervalSinceNow: -345600)),
            ]
        ),
        Order(
            id: 7,
            product: products[2],
            quantity: 1,
            statusHistory: [
                OrderStatusEntry(status: .pending, timestamp: Date(timeIntervalSinceNow: -7200)),
            ]
        ),
    ]

    static func order(id: Int) -> Order? {
        orders.first { $0.id == id }
    }

    static func product(id: Int) -> Product? {
        products.first { $0.id == id }
    }
}
