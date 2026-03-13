import SwiftUI

struct PracticeCard: View {
    let exercise: Exercise
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: exercise.icon)
                    .font(.title2)
                    .foregroundStyle(DesignTokens.Colors.accent)
                    .frame(width: 40, height: 40)
                    .background(DesignTokens.Colors.accentSoft.opacity(0.3))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(exercise.nameHe)
                        .font(AppFont.headline)
                        .foregroundStyle(DesignTokens.Colors.foreground)
                    Text(exercise.subtitleHe)
                        .font(AppFont.caption)
                        .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))

                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Badge(text: "\(exercise.durationSeconds / 60) דק׳")
                        Badge(text: exercise.category.rawValue, color: DesignTokens.Colors.calm)
                    }
                }

                Spacer()

                Button {
                    HapticManager.light()
                    onToggleFavorite()
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundStyle(isFavorite ? .yellow : DesignTokens.Colors.line)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
