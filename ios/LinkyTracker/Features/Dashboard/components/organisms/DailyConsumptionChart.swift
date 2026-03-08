import Charts
import SwiftUI

struct DailyConsumptionChart: View {
    let data: [Item]

    struct Item: Identifiable {
        let id: String
        let date: Date
        let kwh: Double
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Consommation quotidienne")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Chart(data) { item in
                BarMark(
                    x: .value("Jour", item.date, unit: .day),
                    y: .value("kWh", item.kwh)
                )
                .foregroundStyle(.blue.gradient)
                .cornerRadius(3)
            }
            .chartYAxisLabel("kWh")
            .frame(height: 200)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DailyConsumptionChart(data: (0..<15).map { day in
        .init(
            id: "\(day)",
            date: Calendar.current.date(byAdding: .day, value: -day, to: .now)!,
            kwh: Double.random(in: 5...25)
        )
    })
    .padding()
}
