import SwiftUI

struct MonthlyDetailList: View {
    let trends: [MonthlyTrendItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(trends.reversed()) { trend in
                MonthRow(
                    month: trend.displayMonth,
                    totalKwh: trend.totalKwh,
                    averageDailyKwh: trend.averageDailyKwh,
                    costEur: trend.estimatedCostEur,
                    evolutionPercent: trend.evolutionPercent
                )

                if trend.id != trends.first?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
