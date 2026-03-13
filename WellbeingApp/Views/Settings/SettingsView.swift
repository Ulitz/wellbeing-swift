import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var showClearAssessments = false
    @State private var showClearPractices = false
    @State private var showResetAll = false

    private var settings: Settings { appState.settings }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Reminder
                    GlassCard {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                            Text("תזכורת שבועית")
                                .font(AppFont.headline)
                                .foregroundStyle(DesignTokens.Colors.foreground)

                            HStack {
                                Text("יום:")
                                    .font(AppFont.body)
                                    .foregroundStyle(DesignTokens.Colors.foreground)
                                Spacer()
                                Picker("", selection: Binding(
                                    get: { settings.reminderDay },
                                    set: { day in appState.updateSettings { $0.reminderDay = day } }
                                )) {
                                    ForEach(0..<7, id: \.self) { i in
                                        Text(AppConstants.daysHe[i]).tag(i)
                                    }
                                }
                                .tint(DesignTokens.Colors.accent)
                            }
                        }
                    }

                    // Practice target
                    GlassCard {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("יעד תרגול יומי")
                                .font(AppFont.headline)
                                .foregroundStyle(DesignTokens.Colors.foreground)

                            Stepper(
                                "\(settings.dailyPracticeMinutes) דקות",
                                value: Binding(
                                    get: { settings.dailyPracticeMinutes },
                                    set: { val in appState.updateSettings { $0.dailyPracticeMinutes = val } }
                                ),
                                in: 2...30
                            )
                            .font(AppFont.body)
                            .foregroundStyle(DesignTokens.Colors.foreground)
                        }
                    }

                    // Audio language
                    GlassCard {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("שפת שמע")
                                .font(AppFont.headline)
                                .foregroundStyle(DesignTokens.Colors.foreground)

                            Picker("", selection: Binding(
                                get: { settings.audioLanguage },
                                set: { lang in appState.updateSettings { $0.audioLanguage = lang } }
                            )) {
                                Text("עברית").tag(AppLanguage.he)
                                Text("ערבית").tag(AppLanguage.ar)
                                Text("רוסית").tag(AppLanguage.ru)
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    // Dark mode
                    GlassCard {
                        Toggle(isOn: Binding(
                            get: { settings.darkMode },
                            set: { val in appState.updateSettings { $0.darkMode = val } }
                        )) {
                            Text("מצב כהה")
                                .font(AppFont.body)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                        }
                        .tint(DesignTokens.Colors.accent)
                    }

                    // Biweekly reminder
                    GlassCard {
                        Toggle(isOn: Binding(
                            get: { settings.biweeklyReminderEnabled },
                            set: { val in appState.updateSettings { $0.biweeklyReminderEnabled = val } }
                        )) {
                            Text("תזכורת דו-שבועית")
                                .font(AppFont.body)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                        }
                        .tint(DesignTokens.Colors.accent)
                    }

                    // Data management
                    GlassCard {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                            Text("ניהול נתונים")
                                .font(AppFont.headline)
                                .foregroundStyle(DesignTokens.Colors.foreground)

                            dangerButton("מחיקת כל השאלונים") {
                                showClearAssessments = true
                            }
                            dangerButton("מחיקת כל התרגולים") {
                                showClearPractices = true
                            }
                            dangerButton("איפוס כל ההגדרות") {
                                showResetAll = true
                            }
                        }
                    }

                    // Disclaimer
                    Text(AppConstants.disclaimerText)
                        .font(AppFont.caption2)
                        .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.lg)

                    Spacer().frame(height: DesignTokens.Spacing.xxl)
                }
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.top, DesignTokens.Spacing.md)
            }
        }
        .navigationTitle("הגדרות")
        .alert("מחיקת שאלונים", isPresented: $showClearAssessments) {
            Button("מחיקה", role: .destructive) { appState.assessmentStore.clearAll() }
            Button("ביטול", role: .cancel) {}
        } message: {
            Text("כל נתוני השאלונים יימחקו לצמיתות.")
        }
        .alert("מחיקת תרגולים", isPresented: $showClearPractices) {
            Button("מחיקה", role: .destructive) { appState.practiceStore.clearAll() }
            Button("ביטול", role: .cancel) {}
        } message: {
            Text("כל נתוני התרגולים יימחקו לצמיתות.")
        }
        .alert("איפוס הגדרות", isPresented: $showResetAll) {
            Button("איפוס", role: .destructive) {
                appState.assessmentStore.clearAll()
                appState.practiceStore.clearAll()
                appState.checkinStore.clearAll()
                appState.meaningStore.clearAll()
                appState.favoritesStore.clearAll()
                appState.resetSettings()
            }
            Button("ביטול", role: .cancel) {}
        } message: {
            Text("כל הנתונים וההגדרות יאופסו.")
        }
    }

    private func dangerButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(AppFont.subheadline)
                    .foregroundStyle(DesignTokens.Colors.danger)
                Spacer()
                Image(systemName: "trash")
                    .foregroundStyle(DesignTokens.Colors.danger)
            }
        }
    }
}
