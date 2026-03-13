import Foundation

enum MoodOption: String, Codable, CaseIterable, Sendable {
    case stable
    case exhausted
    case overwhelmed
    case apathetic
    case needsBreak = "needs_break"
}
