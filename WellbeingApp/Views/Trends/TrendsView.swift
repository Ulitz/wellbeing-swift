import SwiftUI

struct TrendsView: View {
    @Environment(AppState.self) private var appState

    private var assessments: [Assessment] {
        Array(appState.assessmentStore.getAll().prefix(8))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    if assessments.count < 2 {
                        emptyState
                    } else {
                        TrendChartView(assessments: assessments)
                            .padding(.horizontal, DesignTokens.Spacing.md)

                        InsightCards(
                            assessments: assessments,
                            practices: appState.practiceStore.getRecent(days: 7),
                            checkins: appState.checkinStore.getRecent(days: 7)
                        )
                        .padding(.horizontal, DesignTokens.Spacing.md)
                    }

                    Spacer().frame(height: DesignTokens.Spacing.xxl)
                }
                .padding(.top, DesignTokens.Spacing.md)
            }
        }
        .navigationTitle("מגמות")
    }

    private var emptyState: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Spacer().frame(height: DesignTokens.Spacing.xxl)
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundStyle(DesignTokens.Colors.line)
            Text("צריך לפחות 2 שאלונים כדי לראות מגמות")
                .font(AppFont.body)
                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.5))
                .multilineTextAlignment(.center)
        }
    }
}
