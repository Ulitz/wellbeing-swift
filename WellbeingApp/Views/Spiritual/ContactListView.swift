import SwiftUI

struct ContactListView: View {
    let contacts: [SpiritualContact]
    let onDelete: (SpiritualContact) -> Void

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(contacts, id: \.id) { contact in
                GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
                    HStack(spacing: DesignTokens.Spacing.md) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text(contact.name)
                                .font(AppFont.headline)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                            Text(contact.role)
                                .font(AppFont.caption)
                                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                        }

                        Spacer()

                        // Call button — sanitize to digits only
                        if let url = URL(string: "tel:\(contact.phone.filter(\.isWholeNumber))"),
                           !contact.phone.filter(\.isWholeNumber).isEmpty {
                            Link(destination: url) {
                                Image(systemName: "phone.fill")
                                    .foregroundStyle(.white)
                                    .padding(DesignTokens.Spacing.sm)
                                    .background(DesignTokens.Colors.success)
                                    .clipShape(Circle())
                            }
                        }

                        // Delete (non-default only)
                        if !contact.isDefault {
                            Button {
                                onDelete(contact)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(DesignTokens.Colors.danger)
                            }
                        }
                    }
                }
            }
        }
    }
}
