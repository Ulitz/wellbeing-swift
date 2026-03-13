import SwiftUI

struct DailyCheckinModal: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var step = 0
    @State private var selectedMood: MoodOption?
    @State private var selectedShift: ShiftCharacteristic?

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Step indicator
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Capsule()
                            .fill(DesignTokens.Colors.accent)
                            .frame(height: 4)
                        Capsule()
                            .fill(step >= 1 ? DesignTokens.Colors.accent : DesignTokens.Colors.line)
                            .frame(height: 4)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.lg)

                    Spacer()

                    if step == 0 {
                        moodStep
                            .transition(DesignTokens.Anim.pageTransition)
                    } else {
                        shiftStep
                            .transition(DesignTokens.Anim.pageTransition)
                    }

                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ביטול") { dismiss() }
                }
            }
        }
    }

    private var moodStep: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Text("איך את/ה מרגיש/ה?")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)

            VStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(MoodOption.allCases, id: \.self) { mood in
                    optionButton(
                        icon: AppConstants.moodIcons[mood] ?? "circle",
                        label: AppConstants.moodLabelsHe[mood] ?? "",
                        isSelected: selectedMood == mood
                    ) {
                        selectedMood = mood
                        HapticManager.selection()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            step = 1
                        }
                    }
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
        }
    }

    private var shiftStep: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Text("מה מאפיין את המשמרת?")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)

            VStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(ShiftCharacteristic.allCases, id: \.self) { shift in
                    optionButton(
                        icon: AppConstants.shiftIcons[shift] ?? "circle",
                        label: AppConstants.shiftLabelsHe[shift] ?? "",
                        isSelected: selectedShift == shift
                    ) {
                        selectedShift = shift
                        HapticManager.medium()
                        saveCheckin()
                    }
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
        }
    }

    private func optionButton(icon: String, label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(isSelected ? DesignTokens.Colors.accent : DesignTokens.Colors.calm)
                        .frame(width: 32)
                    Text(label)
                        .font(AppFont.body)
                        .foregroundStyle(DesignTokens.Colors.foreground)
                    Spacer()
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("checkin-option-\(label)")
    }

    private func saveCheckin() {
        guard let mood = selectedMood, let shift = selectedShift else { return }
        let checkin = DailyCheckin(
            id: UUID().uuidString,
            date: Date(),
            mood: mood,
            shiftCharacteristic: shift
        )
        appState.checkinStore.save(checkin)
        dismiss()
    }
}
