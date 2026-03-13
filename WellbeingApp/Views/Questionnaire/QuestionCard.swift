import SwiftUI

struct QuestionCard: View {
    let question: QuestionDef
    let selectedAnswer: Int
    let onSelect: (Int) -> Void

    var body: some View {
        GlassCard {
            VStack(spacing: DesignTokens.Spacing.lg) {
                Text(question.textHe)
                    .font(AppFont.title3)
                    .foregroundStyle(DesignTokens.Colors.foreground)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(0..<5, id: \.self) { value in
                        HStack {
                            Text(AppConstants.scaleLabels[value])
                                .font(AppFont.body)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                            Spacer()
                            Circle()
                                .fill(selectedAnswer == value
                                    ? DesignTokens.Colors.accent
                                    : DesignTokens.Colors.line.opacity(0.4))
                                .frame(width: 24, height: 24)
                                .overlay {
                                    if selectedAnswer == value {
                                        Image(systemName: "checkmark")
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSelect(value)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityIdentifier("likert-option-\(value)")
                    }
                }
            }
        }
    }
}
