import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false

    var body: some View {
        Button {
            HapticManager.medium()
            action()
        } label: {
            Text(title)
                .font(AppFont.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignTokens.Spacing.md)
                .background(isDisabled ? DesignTokens.Colors.line : DesignTokens.Colors.accent)
                .clipShape(Capsule())
                .opacity(isDisabled ? 0.6 : 1.0)
        }
        .disabled(isDisabled)
    }
}
