import SwiftUI

struct PracticePlayerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let exerciseId: ExerciseId

    @State private var currentStep = 0
    @State private var elapsed = 0
    @State private var isPlaying = false
    @State private var showRating = false
    @State private var rating = 0
    @State private var textResponses: [String] = []
    @State private var currentText = ""
    @State private var timerTask: Task<Void, Never>?

    private var exercise: Exercise? { ExerciseData.find(exerciseId) }

    private var isTextBased: Bool {
        exercise?.steps.first?.responseMode == "text"
    }

    var body: some View {
        ZStack {
            AppBackground()

            if let exercise {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    if showRating {
                        ratingView
                    } else if isTextBased {
                        textExerciseView(exercise)
                    } else {
                        timerExerciseView(exercise)
                    }
                }
            }
        }
        .navigationTitle(exercise?.nameHe ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let exercise, isTextBased {
                textResponses = Array(repeating: "", count: exercise.steps.count)
            }
        }
    }

    // MARK: - Timer-based exercise

    private func timerExerciseView(_ exercise: Exercise) -> some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Spacer()

            // Breathing circle
            BreathingCircle(
                animation: exercise.steps[safe: currentStep]?.animation ?? .idle,
                durationSeconds: exercise.steps[safe: currentStep]?.durationSeconds ?? 4
            )

            // Step instruction
            Text(exercise.steps[safe: currentStep]?.instruction ?? "")
                .font(AppFont.title3)
                .foregroundStyle(DesignTokens.Colors.foreground)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.lg)

            // Timer
            TimerDisplay(elapsed: elapsed, total: exercise.durationSeconds)

            // Step progress
            Text("שלב \(currentStep + 1) מתוך \(exercise.steps.count)")
                .font(AppFont.caption)
                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.5))

            Spacer()

            // Controls
            HStack(spacing: DesignTokens.Spacing.xl) {
                Button {
                    elapsed = 0
                    currentStep = 0
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                        .foregroundStyle(DesignTokens.Colors.calm)
                }

                Button {
                    isPlaying.toggle()
                    if isPlaying {
                        startTimer()
                    } else {
                        timerTask?.cancel()
                    }
                } label: {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(DesignTokens.Colors.accent)
                }

                Button {
                    showRating = true
                } label: {
                    Image(systemName: "checkmark.circle")
                        .font(.title2)
                        .foregroundStyle(DesignTokens.Colors.calm)
                }
            }
            .padding(.bottom, DesignTokens.Spacing.xl)
        }
    }

    // MARK: - Text-based exercise

    private func textExerciseView(_ exercise: Exercise) -> some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            ProgressBar(current: currentStep + 1, total: exercise.steps.count)
                .padding(.horizontal, DesignTokens.Spacing.lg)

            Spacer()

            Text(exercise.steps[safe: currentStep]?.instruction ?? "")
                .font(AppFont.title3)
                .foregroundStyle(DesignTokens.Colors.foreground)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.lg)

            GlassCard {
                TextField("כתוב/י כאן...", text: $currentText, axis: .vertical)
                    .font(AppFont.body)
                    .foregroundStyle(DesignTokens.Colors.foreground)
                    .lineLimit(5...10)
            }
            .padding(.horizontal, DesignTokens.Spacing.md)

            Spacer()

            PrimaryButton(title: currentStep < exercise.steps.count - 1 ? "הבא" : "סיום") {
                textResponses[currentStep] = currentText
                if currentStep < exercise.steps.count - 1 {
                    currentText = textResponses[currentStep + 1]
                    withAnimation { currentStep += 1 }
                } else {
                    showRating = true
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.bottom, DesignTokens.Spacing.lg)
        }
    }

    // MARK: - Rating

    private var ratingView: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Spacer()

            Text("איך הרגיש?")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)

            HStack(spacing: DesignTokens.Spacing.md) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        rating = star
                        HapticManager.selection()
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.title)
                            .foregroundStyle(star <= rating ? .yellow : DesignTokens.Colors.line)
                    }
                }
            }

            Spacer()

            PrimaryButton(title: "סיימתי", action: savePractice, isDisabled: rating == 0)
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.bottom, DesignTokens.Spacing.lg)
        }
    }

    // MARK: - Logic

    private func startTimer() {
        timerTask?.cancel()
        guard let exercise else { return }
        timerTask = Task { @MainActor in
            while isPlaying && elapsed < exercise.durationSeconds && !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled, isPlaying else { break }
                elapsed += 1
                updateStep(exercise: exercise)
            }
            if elapsed >= exercise.durationSeconds {
                isPlaying = false
                HapticManager.success()
                showRating = true
            }
        }
    }

    private func updateStep(exercise: Exercise) {
        var accumulated = 0
        for (i, step) in exercise.steps.enumerated() {
            accumulated += step.durationSeconds
            if elapsed < accumulated {
                currentStep = i
                return
            }
        }
    }

    private func savePractice() {
        let responses: [ExerciseTextResponse]? = isTextBased
            ? textResponses.enumerated().map { i, text in
                ExerciseTextResponse(
                    prompt: exercise?.steps[safe: i]?.instruction ?? "Step \(i + 1)",
                    response: text
                )
            }
            : nil

        let log = PracticeLog(
            id: UUID().uuidString,
            date: Date(),
            exerciseId: exerciseId,
            durationSeconds: elapsed,
            completed: true,
            rating: rating,
            textResponses: responses
        )
        appState.practiceStore.log(log)
        dismiss()
    }
}

// Safe array subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
