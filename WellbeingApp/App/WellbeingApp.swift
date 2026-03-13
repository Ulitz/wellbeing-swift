import SwiftUI

@main
struct WellbeingApp: App {
    @State private var appState: AppState

    init() {
        let state = AppState()

        // Handle UI test launch arguments (debug/test builds only)
        #if DEBUG
        if CommandLine.arguments.contains("-reset-state") {
            state.resetSettings()
            state.assessmentStore.clearAll()
            state.checkinStore.clearAll()
            state.practiceStore.clearAll()
            state.meaningStore.clearAll()
            state.favoritesStore.clearAll()
        }

        if CommandLine.arguments.contains("-onboarded") {
            state.updateSettings { $0.onboarded = true }
        }
        #endif

        _appState = State(initialValue: state)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "he"))
                .preferredColorScheme(appState.settings.darkMode ? .dark : .light)
        }
    }
}

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.settings.onboarded {
                MainTabView()
            } else {
                WelcomeView()
            }
        }
    }
}
