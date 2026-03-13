import Foundation

struct QuestionDef: Codable, Equatable, Sendable {
    let index: Int
    let textHe: String
    let isReverse: Bool
    let category: String
}
