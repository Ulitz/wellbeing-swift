import SwiftUI
import Charts

struct TrendChartView: View {
    let assessments: [Assessment]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("ציון לאורך זמן")
                    .font(AppFont.headline)
                    .foregroundStyle(DesignTokens.Colors.foreground)

                Chart {
                    ForEach(assessments.reversed(), id: \.id) { assessment in
                        LineMark(
                            x: .value("תאריך", assessment.date),
                            y: .value("ציון", assessment.totalScore)
                        )
                        .foregroundStyle(DesignTokens.Colors.accent)
                        .symbol(Circle())

                        PointMark(
                            x: .value("תאריך", assessment.date),
                            y: .value("ציון", assessment.totalScore)
                        )
                        .foregroundStyle(DesignTokens.Colors.levelColor(for: assessment.level))
                    }

                    // Level threshold lines
                    RuleMark(y: .value("", 10))
                        .foregroundStyle(DesignTokens.Colors.levelGreen.opacity(0.3))
                        .lineStyle(StrokeStyle(dash: [4]))
                    RuleMark(y: .value("", 20))
                        .foregroundStyle(DesignTokens.Colors.levelYellow.opacity(0.3))
                        .lineStyle(StrokeStyle(dash: [4]))
                    RuleMark(y: .value("", 30))
                        .foregroundStyle(DesignTokens.Colors.levelOrange.opacity(0.3))
                        .lineStyle(StrokeStyle(dash: [4]))
                }
                .chartYScale(domain: 0...40)
                .chartYAxisLabel("ציון")
                .frame(height: 200)
            }
        }
    }
}
