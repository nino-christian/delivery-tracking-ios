import Foundation

struct Product: Equatable, Identifiable, Codable {
    let id: Int
    var name: String
    var manufacturer: String
}
