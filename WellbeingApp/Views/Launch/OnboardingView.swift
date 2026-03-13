import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var step = 0
    @State private var reminderDay = 0
    @State private var reminderTime = Date()
    @State private var practiceMinutes = 5
    @State private var darkMode = true

    private let totalSteps = 4

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: DesignTokens.Spacing.lg) {
                // Progress
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(0..<totalSteps, id: \.self) { i in
                        Capsule()
                            .fill(i <= step ? DesignTokens.Colors.accent : DesignTokens.Colors.line)
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.top, DesignTokens.Spacing.md)

                Spacer()

                Group {
                    switch step {
                    case 0: reminderStep
                    case 1: practiceTargetStep
                    case 2: contactsStep
                    default: darkModeStep
                    }
                }
                .transition(DesignTokens.Anim.pageTransition)

                Spacer()

                PrimaryButton(title: step < totalSteps - 1 ? "הבא" : "סיום") {
                    if step < totalSteps - 1 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            step += 1
                        }
                    } else {
                        completeOnboarding()
                    }
                }
                .accessibilityIdentifier("onboarding-next-button")
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.bottom, DesignTokens.Spacing.lg)
            }
        }
        .accessibilityIdentifier("onboarding-view")
        .navigationBarBackButtonHidden()
    }

    // MARK: - Steps

    private var reminderStep: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 48))
                .foregroundStyle(DesignTokens.Colors.accent)

            Text("בחירת יום ושעת תזכורת")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)

            GlassCard {
                VStack(spacing: DesignTokens.Spacing.md) {
                    Picker("יום", selection: $reminderDay) {
                        ForEach(0..<7, id: \.self) { i in
                            Text(AppConstants.daysHe[i]).tag(i)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)

                    DatePicker("שעה", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .font(AppFont.body)
                        .environment(\.locale, Locale(identifier: "he"))
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
        }
    }

    private var practiceTargetStep: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: "timer")
                .font(.system(size: 48))
                .foregroundStyle(DesignTokens.Colors.accent)

            Text("יעד תרגול יומי")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)

            GlassCard {
                VStack(spacing: DesignTokens.Spacing.md) {
                    Text("\(practiceMinutes) דקות")
                        .font(AppFont.largeTitle)
                        .foregroundStyle(DesignTokens.Colors.accent)

                    Slider(value: Binding(
                        get: { Double(practiceMinutes) },
                        set: { practiceMinutes = Int($0) }
                    ), in: 2...30, step: 1)
                    .tint(DesignTokens.Colors.accent)

                    Text("מומלץ להתחיל מ-5 דקות ולהגדיל בהדרגה")
                        .font(AppFont.caption)
                        .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
        }
    }

    private var contactsStep: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 48))
                .foregroundStyle(DesignTokens.Colors.accent)

            Text("אנשי קשר לתמיכה")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)

            GlassCard {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    ForEach(DefaultContacts.all, id: \.id) { contact in
                        HStack {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                Text(contact.name)
                                    .font(AppFont.headline)
                                    .foregroundStyle(DesignTokens.Colors.foreground)
                                Text(contact.role)
                                    .font(AppFont.caption)
                                    .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                            }
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(DesignTokens.Colors.success)
                        }
                    }

                    Text("ניתן להוסיף אנשי קשר נוספים בהגדרות")
                        .font(AppFont.caption)
                        .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.5))
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
        }
    }

    private var darkModeStep: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: darkMode ? "moon.stars.fill" : "sun.max.fill")
                .font(.system(size: 48))
                .foregroundStyle(DesignTokens.Colors.accent)

            Text("מצב תצוגה")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)

            GlassCard {
                Toggle(isOn: $darkMode) {
                    Text("מצב כהה")
                        .font(AppFont.body)
                        .foregroundStyle(DesignTokens.Colors.foreground)
                }
                .tint(DesignTokens.Colors.accent)
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
        }
    }

    // MARK: - Actions

    private func completeOnboarding() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        let timeStr = String(format: "%02d:%02d", components.hour ?? 18, components.minute ?? 0)

        appState.updateSettings { settings in
            settings.onboarded = true
            settings.reminderDay = reminderDay
            settings.reminderTime = timeStr
            settings.dailyPracticeMinutes = practiceMinutes
            settings.darkMode = darkMode
        }
    }
}
