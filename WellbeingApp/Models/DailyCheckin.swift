import Foundation

struct DailyCheckin: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let date: Date
    let mood: MoodOption
    let shiftCharacteristic: ShiftCharacteristic
}
