import SwiftUI

struct HcHpLegendRow: View {
    let color: Color
    let label: String
    let kwh: Double
    let costEur: Double
    let percent: Double

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(label)
                .font(.subheadline)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 4) {
                    KwhLabel(kwh, fontSize: .subheadline)
                    Text("(\(String(format: "%.0f", percent))%)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                EurLabel(costEur, fontSize: .caption)
            }
        }
    }
}

#Preview {
    List {
        HcHpLegendRow(color: .green, label: "Heures Creuses", kwh: 138.3, costEur: 24.05, percent: 40)
        HcHpLegendRow(color: .orange, label: "Heures Pleines", kwh: 207.5, costEur: 47.72, percent: 60)
    }
}
