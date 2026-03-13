import SwiftUI

struct AssessmentStatusCard: View {
    let latestAssessment: Assessment?
    let onStart: () -> Void

    var body: some View {
        Button(action: onStart) {
            GlassCard {
                HStack(spacing: DesignTokens.Spacing.md) {
                    Image(systemName: "chart.bar.fill")
                        .font(.title)
                        .foregroundStyle(DesignTokens.Colors.accent)

                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text("שאלון רווחה שבועי")
                            .font(AppFont.headline)
                            .foregroundStyle(DesignTokens.Colors.foreground)

                        if let assessment = latestAssessment {
                            let daysSince = Calendar.current.dateComponents([.day], from: assessment.date, to: Date()).day ?? 0
                            if daysSince >= 7 {
                                Text("הגיע הזמן למילוי חדש")
                                    .font(AppFont.caption)
                                    .foregroundStyle(DesignTokens.Colors.warning)
                            } else {
                                Text("מולא לפני \(daysSince) ימים")
                                    .font(AppFont.caption)
                                    .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                            }
                        } else {
                            Text("עדיין לא מולא — התחל עכשיו")
                                .font(AppFont.caption)
                                .foregroundStyle(DesignTokens.Colors.accent)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.left")
                        .foregroundStyle(DesignTokens.Colors.accent)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("assessment-status-card")
    }
}
