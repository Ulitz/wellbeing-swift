import SwiftUI

struct WelcomeView: View {
    @Environment(AppState.self) private var appState
    @State private var showOnboarding = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        Spacer().frame(height: DesignTokens.Spacing.xxl)

                        Text(AppConstants.appName)
                            .font(AppFont.largeTitle)
                            .foregroundStyle(DesignTokens.Colors.foreground)
                            .multilineTextAlignment(.center)

                        Text(AppConstants.disclaimerText)
                            .font(AppFont.footnote)
                            .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DesignTokens.Spacing.lg)

                        // Privacy badge
                        GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
                            HStack(spacing: DesignTokens.Spacing.sm) {
                                Image(systemName: "lock.shield.fill")
                                    .foregroundStyle(DesignTokens.Colors.success)
                                Text("כל הנתונים נשמרים במכשיר שלך בלבד")
                                    .font(AppFont.subheadline)
                                    .foregroundStyle(DesignTokens.Colors.foreground)
                            }
                        }
                        .padding(.horizontal, DesignTokens.Spacing.lg)

                        // Feature highlights
                        VStack(spacing: DesignTokens.Spacing.md) {
                            featureCard(icon: "chart.bar.fill", title: "ניטור שבועי", subtitle: "שאלון קצר לבדיקת מצב הרווחה שלך")
                            featureCard(icon: "figure.mind.and.body", title: "תרגולי ויסות", subtitle: "נשימות, מדיטציה, הרפיה ועוד")
                            featureCard(icon: "person.2.fill", title: "ליווי רוחני", subtitle: "גישה מהירה לתמיכה אנושית")
                        }
                        .padding(.horizontal, DesignTokens.Spacing.lg)

                        Spacer().frame(height: DesignTokens.Spacing.md)

                        PrimaryButton(title: "התחל") {
                            showOnboarding = true
                        }
                        .accessibilityIdentifier("welcome-start-button")
                        .padding(.horizontal, DesignTokens.Spacing.xl)

                        Spacer().frame(height: DesignTokens.Spacing.lg)
                    }
                }
            }
            .navigationDestination(isPresented: $showOnboarding) {
                OnboardingView()
            }
        }
    }

    private func featureCard(icon: String, title: String, subtitle: String) -> some View {
        GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(DesignTokens.Colors.accent)
                    .frame(width: 44)

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(title)
                        .font(AppFont.headline)
                        .foregroundStyle(DesignTokens.Colors.foreground)
                    Text(subtitle)
                        .font(AppFont.caption)
                        .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.7))
                }

                Spacer()
            }
        }
    }
}
