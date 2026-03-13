import Foundation

struct MeaningMoment: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let date: Date
    let selection: MeaningOption
}
