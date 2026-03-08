import SwiftUI

struct ConsumptionStatRow: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .fontWeight(.semibold)
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    List {
        ConsumptionStatRow(label: "Total", value: "345.8", unit: "kWh")
        ConsumptionStatRow(label: "Moyenne/jour", value: "11.5", unit: "kWh")
    }
}
