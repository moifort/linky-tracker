import SwiftUI

struct DashboardSummaryCard: View {
    let totalKwh: Double
    let averageDailyKwh: Double
    let estimatedCostEur: Double
    let evolutionPercent: Double?
    let daysWithData: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ce mois")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    KwhLabel(totalKwh, fontSize: .title)
                }
                Spacer()
                if let evolutionPercent {
                    TrendBadge(percent: evolutionPercent)
                }
            }

            Divider()

            VStack(spacing: 8) {
                ConsumptionStatRow(
                    label: "Moyenne/jour",
                    value: String(format: "%.1f", averageDailyKwh),
                    unit: "kWh"
                )
                ConsumptionStatRow(
                    label: "Jours avec données",
                    value: "\(daysWithData)",
                    unit: "j"
                )
                CostEstimateRow(
                    label: "Estimation",
                    costEur: estimatedCostEur,
                    trendPercent: nil
                )
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DashboardSummaryCard(
        totalKwh: 345.8,
        averageDailyKwh: 11.5,
        estimatedCostEur: 85.50,
        evolutionPercent: 12.3,
        daysWithData: 15
    )
    .padding()
}
