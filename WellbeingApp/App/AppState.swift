import Foundation
import Observation

@Observable
@MainActor
final class AppState {
    private let storage: StorageManager
    let assessmentStore: AssessmentStore
    let checkinStore: CheckinStore
    let practiceStore: PracticeStore
    let settingsStore: SettingsStore
    let meaningStore: MeaningStore
    let favoritesStore: FavoritesStore

    private(set) var settings: Settings

    // Navigation state
    var showCheckinModal = false
    var showMeaningModal = false
    var showQuestionnaire = false
    var selectedTab: AppTab = .home

    enum AppTab: Int, CaseIterable {
        case home, practice, spiritual, trends, settings
    }

    init(storage: StorageManager = StorageManager()) {
        self.storage = storage
        self.assessmentStore = AssessmentStore(storage: storage)
        self.checkinStore = CheckinStore(storage: storage)
        self.practiceStore = PracticeStore(storage: storage)
        self.settingsStore = SettingsStore(storage: storage)
        self.meaningStore = MeaningStore(storage: storage)
        self.favoritesStore = FavoritesStore(storage: storage)
        self.settings = settingsStore.get()
    }

    func updateSettings(_ modify: (inout Settings) -> Void) {
        settingsStore.update(modify)
        settings = settingsStore.get()
    }

    func resetSettings() {
        settingsStore.save(.default)
        settings = settingsStore.get()
    }

    func addContact(name: String, role: String, phone: String) -> SpiritualContact {
        let contact = settingsStore.addContact(name: name, role: role, phone: phone)
        settings = settingsStore.get()
        return contact
    }

    func removeContact(id: String) {
        settingsStore.removeContact(id: id)
        settings = settingsStore.get()
    }
}
