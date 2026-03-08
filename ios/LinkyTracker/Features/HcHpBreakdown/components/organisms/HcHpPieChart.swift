import Charts
import SwiftUI

struct HcHpPieChart: View {
    let hcKwh: Double
    let hpKwh: Double
    let hcPercent: Double
    let hpPercent: Double
    let hcCostEur: Double
    let hpCostEur: Double

    private var segments: [Segment] {
        [
            Segment(label: "HC", value: hcPercent, color: .green),
            Segment(label: "HP", value: hpPercent, color: .orange),
        ]
    }

    var body: some View {
        VStack(spacing: 16) {
            Chart(segments) { segment in
                SectorMark(
                    angle: .value("Percent", segment.value),
                    innerRadius: .ratio(0.5)
                )
                .foregroundStyle(segment.color)
                .annotation(position: .overlay) {
                    Text("\(String(format: "%.0f", segment.value))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 180)

            VStack(spacing: 8) {
                HcHpLegendRow(
                    color: .green,
                    label: "Heures Creuses",
                    kwh: hcKwh,
                    costEur: hcCostEur,
                    percent: hcPercent
                )
                Divider()
                HcHpLegendRow(
                    color: .orange,
                    label: "Heures Pleines",
                    kwh: hpKwh,
                    costEur: hpCostEur,
                    percent: hpPercent
                )
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct Segment: Identifiable {
    let label: String
    let value: Double
    let color: Color
    var id: String { label }
}

#Preview {
    HcHpPieChart(
        hcKwh: 138.3, hpKwh: 207.5,
        hcPercent: 40, hpPercent: 60,
        hcCostEur: 24.05, hpCostEur: 47.72
    )
    .padding()
}
