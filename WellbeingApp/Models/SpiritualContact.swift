import Foundation

struct SpiritualContact: Codable, Identifiable, Equatable, Sendable {
    let id: String
    var name: String
    var role: String
    var phone: String
    let isDefault: Bool
}
