import Charts
import SwiftUI

struct MonthlyComparisonChart: View {
    let data: [Item]

    struct Item: Identifiable {
        let id: String
        let month: String
        let kwh: Double
        let costEur: Double
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Consommation mensuelle")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Chart(data) { item in
                BarMark(
                    x: .value("Mois", item.month),
                    y: .value("kWh", item.kwh)
                )
                .foregroundStyle(.blue.gradient)
                .cornerRadius(3)
            }
            .frame(height: 200)
            .chartYAxisLabel("kWh")
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    MonthlyComparisonChart(data: [
        .init(id: "1", month: "Oct", kwh: 350, costEur: 72),
        .init(id: "2", month: "Nov", kwh: 420, costEur: 86),
        .init(id: "3", month: "Déc", kwh: 480, costEur: 99),
        .init(id: "4", month: "Jan", kwh: 450, costEur: 92),
    ])
    .padding()
}
