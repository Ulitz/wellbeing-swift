import SwiftUI

struct SpiritualCareView: View {
    @Environment(AppState.self) private var appState
    @State private var showAddContact = false

    private var contacts: [SpiritualContact] {
        DefaultContacts.all + appState.settings.spiritualContacts
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Intro
                    GlassCard {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("ליווי רוחני")
                                .font(AppFont.title2)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                            Text(AppConstants.spiritualCareIntro)
                                .font(AppFont.callout)
                                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.8))
                            Text(AppConstants.spiritualCareSubtitle)
                                .font(AppFont.caption)
                                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md)

                    // Contact list
                    ContactListView(contacts: contacts, onDelete: { contact in
                        appState.removeContact(id: contact.id)
                    })
                    .padding(.horizontal, DesignTokens.Spacing.md)

                    // Add contact button
                    Button {
                        showAddContact = true
                    } label: {
                        GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(DesignTokens.Colors.accent)
                                Text("הוספת איש קשר")
                                    .font(AppFont.subheadline)
                                    .foregroundStyle(DesignTokens.Colors.accent)
                                Spacer()
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, DesignTokens.Spacing.md)

                    // Spiritual text from latest assessment
                    if let assessment = appState.assessmentStore.getLatest() {
                        let text = SpiritualTextSelector.select(
                            level: assessment.level, flags: assessment.flags, history: []
                        )
                        if let text {
                            SpiritualTextCard(title: text.title, bodyText: text.body)
                                .padding(.horizontal, DesignTokens.Spacing.md)
                        }
                    }

                    Spacer().frame(height: DesignTokens.Spacing.xxl)
                }
                .padding(.top, DesignTokens.Spacing.md)
            }
        }
        .navigationTitle("ליווי רוחני")
        .sheet(isPresented: $showAddContact) {
            AddContactForm { contact in
                _ = appState.addContact(
                    name: contact.name, role: contact.role, phone: contact.phone
                )
                showAddContact = false
            }
        }
    }
}
