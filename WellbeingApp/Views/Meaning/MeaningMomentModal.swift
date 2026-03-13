import SwiftUI

struct MeaningMomentModal: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(spacing: DesignTokens.Spacing.lg) {
                    Spacer()

                    Text("היה היום רגע של משמעות?")
                        .font(AppFont.title2)
                        .foregroundStyle(DesignTokens.Colors.foreground)

                    VStack(spacing: DesignTokens.Spacing.sm) {
                        ForEach(MeaningOption.allCases, id: \.self) { option in
                            Button {
                                saveMeaning(option)
                            } label: {
                                GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
                                    HStack(spacing: DesignTokens.Spacing.md) {
                                        Image(systemName: AppConstants.meaningIcons[option] ?? "circle")
                                            .font(.title2)
                                            .foregroundStyle(DesignTokens.Colors.accent)
                                            .frame(width: 32)
                                        Text(AppConstants.meaningLabelsHe[option] ?? "")
                                            .font(AppFont.body)
                                            .foregroundStyle(DesignTokens.Colors.foreground)
                                        Spacer()
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, DesignTokens.Spacing.lg)

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

    private func saveMeaning(_ option: MeaningOption) {
        let moment = MeaningMoment(
            id: UUID().uuidString,
            date: Date(),
            selection: option
        )
        appState.meaningStore.save(moment)
        HapticManager.success()
        dismiss()
    }
}
