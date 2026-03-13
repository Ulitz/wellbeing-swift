import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        TabView(selection: $state.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("בית", systemImage: "house.fill") }
            .tag(AppState.AppTab.home)

            NavigationStack {
                PracticeLibraryView()
            }
            .tabItem { Label("תרגול", systemImage: "figure.mind.and.body") }
            .tag(AppState.AppTab.practice)

            NavigationStack {
                SpiritualCareView()
            }
            .tabItem { Label("ליווי רוחני", systemImage: "heart.circle.fill") }
            .tag(AppState.AppTab.spiritual)

            NavigationStack {
                TrendsView()
            }
            .tabItem { Label("מגמות", systemImage: "chart.line.uptrend.xyaxis") }
            .tag(AppState.AppTab.trends)

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("הגדרות", systemImage: "gearshape.fill") }
            .tag(AppState.AppTab.settings)
        }
        .tint(DesignTokens.Colors.accent)
    }
}
