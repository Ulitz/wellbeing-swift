import SwiftUI

struct SegmentedControl: View {
    let options: [String]
    @Binding var selected: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button {
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selected = index
                    }
                } label: {
                    Text(options[index])
                        .font(AppFont.subheadline)
                        .foregroundStyle(selected == index
                            ? DesignTokens.Colors.foreground
                            : DesignTokens.Colors.foreground.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .background(
                            selected == index
                                ? DesignTokens.Colors.surfaceStrong
                                : Color.clear
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(DesignTokens.Spacing.xs)
        .background(DesignTokens.Colors.surface)
        .clipShape(Capsule())
    }
}
