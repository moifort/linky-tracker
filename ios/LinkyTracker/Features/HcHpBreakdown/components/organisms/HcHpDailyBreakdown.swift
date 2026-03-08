import Charts
import SwiftUI

struct HcHpDailyBreakdown: View {
    let loadCurves: [DailyLoadCurve]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Courbe de charge (7 derniers jours)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let latestCurve = loadCurves.last {
                Chart(latestCurve.readings, id: \.slot) { reading in
                    BarMark(
                        x: .value("Heure", reading.slot),
                        y: .value("W", reading.averageW)
                    )
                    .foregroundStyle(.blue.gradient)
                    .cornerRadius(2)
                }
                .frame(height: 150)
                .chartXAxis {
                    AxisMarks(values: .stride(by: 6)) { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxisLabel("W")
            } else {
                Text("Aucune donnée")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 150)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
