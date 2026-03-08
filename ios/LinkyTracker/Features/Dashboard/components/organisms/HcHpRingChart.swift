import Charts
import SwiftUI

struct HcHpRingChart: View {
    let hcPercent: Double
    let hpPercent: Double
    let hcKwh: Double
    let hpKwh: Double

    private var segments: [Segment] {
        [
            Segment(label: "HC", value: hcPercent, color: .green),
            Segment(label: "HP", value: hpPercent, color: .orange),
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Répartition HC/HP")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 24) {
                Chart(segments) { segment in
                    SectorMark(
                        angle: .value("Percent", segment.value),
                        innerRadius: .ratio(0.6)
                    )
                    .foregroundStyle(segment.color)
                }
                .frame(width: 100, height: 100)

                VStack(alignment: .leading, spacing: 8) {
                    LegendRow(color: .green, label: "Heures Creuses", kwh: hcKwh, percent: hcPercent)
                    LegendRow(color: .orange, label: "Heures Pleines", kwh: hpKwh, percent: hpPercent)
                }
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

private struct LegendRow: View {
    let color: Color
    let label: String
    let kwh: Double
    let percent: Double

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                Text("\(String(format: "%.1f", kwh)) kWh (\(String(format: "%.0f", percent))%)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HcHpRingChart(hcPercent: 40, hpPercent: 60, hcKwh: 138.3, hpKwh: 207.5)
        .padding()
}
