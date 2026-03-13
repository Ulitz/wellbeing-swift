import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState

    private var todayCheckin: DailyCheckin? {
        appState.checkinStore.getToday()
    }

    private var latestAssessment: Assessment? {
        appState.assessmentStore.getLatest()
    }

    private var todayMeaning: MeaningMoment? {
        appState.meaningStore.getToday()
    }

    var body: some View {
        @Bindable var state = appState

        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Header
                    Text(AppConstants.appShortName)
                        .font(AppFont.title)
                        .foregroundStyle(DesignTokens.Colors.foreground)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                        .padding(.top, DesignTokens.Spacing.md)

                    // Daily check-in
                    if todayCheckin == nil {
                        DailyCheckinCard {
                            state.showCheckinModal = true
                        }
                        .padding(.horizontal, DesignTokens.Spacing.md)
                    } else {
                        TailoredResponseCard(checkin: todayCheckin!)
                            .padding(.horizontal, DesignTokens.Spacing.md)
                    }

                    // Assessment status
                    AssessmentStatusCard(latestAssessment: latestAssessment) {
                        state.showQuestionnaire = true
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md)

                    // Weekly summary
                    WeeklySummaryCard(
                        practiceCount: appState.practiceStore.getRecent(days: 7).count,
                        checkinCount: appState.checkinStore.getRecent(days: 7).count,
                        meaningCount: appState.meaningStore.getAll().filter { moment in
                            moment.date >= DateFormatting.daysAgo(7)
                        }.count
                    )
                    .padding(.horizontal, DesignTokens.Spacing.md)

                    // Meaning moment (shows after 14:00 if not completed)
                    if todayMeaning == nil && Calendar.current.component(.hour, from: Date()) >= 14 {
                        MeaningMomentCard {
                            state.showMeaningModal = true
                        }
                        .padding(.horizontal, DesignTokens.Spacing.md)
                    }

                    Spacer().frame(height: DesignTokens.Spacing.xl)
                }
            }
        }
        .sheet(isPresented: $state.showCheckinModal) {
            DailyCheckinModal()
        }
        .sheet(isPresented: $state.showMeaningModal) {
            MeaningMomentModal()
        }
        .fullScreenCover(isPresented: $state.showQuestionnaire) {
            QuestionnaireView()
        }
    }
}
