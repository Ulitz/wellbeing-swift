import SwiftUI

struct PracticeLibraryView: View {
    @Environment(AppState.self) private var appState
    @State private var viewMode = 0
    private let viewModeLabels = ["רשימה", "זרימה", "מועדפים"]

    private var sections: [PracticeSection] {
        PersonalizationEngine.buildSections(
            todayCheckin: appState.checkinStore.getToday(),
            preferredMinutes: appState.settings.dailyPracticeMinutes,
            recentPractices: appState.practiceStore.getRecent(days: 14),
            favoriteIds: appState.favoritesStore.getAll()
        )
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                SegmentedControl(options: viewModeLabels, selected: $viewMode)
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .padding(.vertical, DesignTokens.Spacing.sm)

                ScrollView {
                    LazyVStack(spacing: DesignTokens.Spacing.md) {
                        switch viewMode {
                        case 2: // Favorites
                            favoritesView
                        default: // List or Flow
                            sectionsView
                        }
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .padding(.bottom, DesignTokens.Spacing.xxl)
                }
            }
        }
        .navigationTitle("תרגול")
        .navigationDestination(for: ExerciseId.self) { id in
            PracticePlayerView(exerciseId: id)
        }
    }

    private var sectionsView: some View {
        ForEach(sections, id: \.titleHe) { section in
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(section.titleHe)
                    .font(AppFont.headline)
                    .foregroundStyle(DesignTokens.Colors.foreground)

                ForEach(section.suggestions, id: \.exerciseId) { suggestion in
                    if let exercise = ExerciseData.find(suggestion.exerciseId) {
                        NavigationLink(value: suggestion.exerciseId) {
                            PracticeCard(exercise: exercise,
                                         isFavorite: appState.favoritesStore.isFavorite(suggestion.exerciseId),
                                         onToggleFavorite: { appState.favoritesStore.toggle(suggestion.exerciseId) })
                        }
                    }
                }
            }
        }
    }

    private var favoritesView: some View {
        Group {
            let favoriteIds = appState.favoritesStore.getAll()
            if favoriteIds.isEmpty {
                VStack(spacing: DesignTokens.Spacing.md) {
                    Image(systemName: "star")
                        .font(.largeTitle)
                        .foregroundStyle(DesignTokens.Colors.line)
                    Text("עדיין לא סימנת מועדפים")
                        .font(AppFont.body)
                        .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, DesignTokens.Spacing.xxl)
            } else {
                ForEach(favoriteIds, id: \.self) { id in
                    if let exercise = ExerciseData.find(id) {
                        NavigationLink(value: id) {
                            PracticeCard(exercise: exercise, isFavorite: true,
                                         onToggleFavorite: { appState.favoritesStore.toggle(id) })
                        }
                    }
                }
            }
        }
    }
}
