import Foundation

enum MeaningOption: String, Codable, CaseIterable, Sendable {
    case patientSmile = "patient_smile"
    case goodFamilyTalk = "good_family_talk"
    case professionalism
    case noMoment = "no_moment"
}
