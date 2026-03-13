import SwiftUI

struct FlagsList: View {
    let flags: [Flag]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("סימנים לתשומת לב")
                    .font(AppFont.headline)
                    .foregroundStyle(DesignTokens.Colors.danger)

                ForEach(flags, id: \.questionKey) { flag in
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(DesignTokens.Colors.warning)
                        Text(AppConstants.categoryLabelsHe[flag.category] ?? flag.category)
                            .font(AppFont.subheadline)
                            .foregroundStyle(DesignTokens.Colors.foreground)
                    }
                }
            }
        }
    }
}
