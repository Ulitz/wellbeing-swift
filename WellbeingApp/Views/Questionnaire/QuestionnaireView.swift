import SwiftUI

struct QuestionnaireView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var answers = Array(repeating: -1, count: QuestionData.questions.count)
    @State private var showResults = false
    @State private var assessment: Assessment?

    private let questions = QuestionData.questions

    private var isLastQuestion: Bool {
        currentIndex >= questions.count - 1
    }

    var body: some View {
        if let assessment, showResults {
            ResultsView(assessment: assessment)
        } else {
            questionnaireContent
        }
    }

    private var questionnaireContent: some View {
        ZStack {
            AppBackground()

            VStack(spacing: DesignTokens.Spacing.lg) {
                // Progress bar
                ProgressBar(current: currentIndex + 1, total: questions.count)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.top, DesignTokens.Spacing.md)

                // Header
                Text(AppConstants.timeWindowPrompt)
                    .font(AppFont.footnote)
                    .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))

                Spacer()

                // Question
                QuestionCard(
                    question: questions[currentIndex],
                    selectedAnswer: answers[currentIndex],
                    onSelect: { answer in
                        answers[currentIndex] = answer
                        HapticManager.selection()
                    }
                )
                .padding(.horizontal, DesignTokens.Spacing.md)

                Spacer()

                // Navigation
                HStack(spacing: DesignTokens.Spacing.md) {
                    if currentIndex > 0 {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                currentIndex -= 1
                            }
                        } label: {
                            Text("הקודם")
                                .font(AppFont.subheadline)
                                .foregroundStyle(DesignTokens.Colors.accent)
                                .padding(.horizontal, DesignTokens.Spacing.lg)
                                .padding(.vertical, DesignTokens.Spacing.sm)
                        }
                    }

                    Spacer()

                    PrimaryButton(
                        title: isLastQuestion ? "סיום" : "הבא",
                        action: {
                            if isLastQuestion {
                                submitAssessment()
                            } else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    currentIndex += 1
                                }
                            }
                        },
                        isDisabled: answers[currentIndex] < 0
                    )
                    .frame(width: 120)
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.bottom, DesignTokens.Spacing.lg)
            }
        }
    }

    private func submitAssessment() {
        let result = ScoringEngine.score(rawAnswers: answers)
        appState.assessmentStore.save(result)
        assessment = result
        HapticManager.success()
        showResults = true
    }
}
