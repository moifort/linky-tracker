import SwiftUI

struct MonthRow: View {
    let month: String
    let totalKwh: Double
    let averageDailyKwh: Double
    let costEur: Double
    let evolutionPercent: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(month)
                    .font(.headline)
                Spacer()
                if let evolutionPercent {
                    TrendBadge(percent: evolutionPercent)
                }
            }

            HStack(spacing: 16) {
                ConsumptionStatRow(
                    label: "Total",
                    value: String(format: "%.1f", totalKwh),
                    unit: "kWh"
                )
            }

            HStack(spacing: 16) {
                HStack {
                    Text("Moy/jour")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f kWh", averageDailyKwh))
                        .font(.caption)
                }
                Spacer()
                HStack {
                    Text("Coût")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.2f €", costEur))
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        MonthRow(month: "Jan 25", totalKwh: 450, averageDailyKwh: 14.5, costEur: 92.30, evolutionPercent: 8.5)
        MonthRow(month: "Déc 24", totalKwh: 415, averageDailyKwh: 13.4, costEur: 85.10, evolutionPercent: nil)
    }
}
