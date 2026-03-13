import SwiftUI

struct AddContactForm: View {
    let onSave: (SpiritualContact) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var role = ""
    @State private var phone = ""

    private var isPhoneValid: Bool {
        let digits = phone.filter(\.isWholeNumber)
        return digits.count >= 9 && digits.count <= 15
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                VStack(spacing: DesignTokens.Spacing.lg) {
                    GlassCard {
                        VStack(spacing: DesignTokens.Spacing.md) {
                            TextField("שם", text: $name)
                                .font(AppFont.body)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                            Divider()
                            TextField("תפקיד", text: $role)
                                .font(AppFont.body)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                            Divider()
                            TextField("טלפון", text: $phone)
                                .font(AppFont.body)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                                .keyboardType(.phonePad)
                        }
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md)

                    PrimaryButton(title: "שמירה", action: {
                        let contact = SpiritualContact(
                            id: UUID().uuidString,
                            name: name,
                            role: role.isEmpty ? "איש קשר" : role,
                            phone: phone,
                            isDefault: false
                        )
                        onSave(contact)
                    }, isDisabled: name.isEmpty || !isPhoneValid)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    Spacer()
                }
                .padding(.top, DesignTokens.Spacing.lg)
            }
            .navigationTitle("הוספת איש קשר")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ביטול") { dismiss() }
                }
            }
        }
    }
}
