import Foundation

enum ShiftCharacteristic: String, Codable, CaseIterable, Sendable {
    case emotionalLoad = "emotional_load"
    case fatigue
    case familyConflict = "family_conflict"
    case patientDeath = "patient_death"
    case senseOfMeaning = "sense_of_meaning"
}
