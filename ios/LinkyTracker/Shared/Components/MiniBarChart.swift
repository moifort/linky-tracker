import Charts
import SwiftUI

struct MiniBarChart: View {
    let data: [Item]

    struct Item: Identifiable {
        let id: String
        let label: String
        let value: Double
    }

    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Day", item.label),
                y: .value("kWh", item.value)
            )
            .foregroundStyle(.blue.gradient)
            .cornerRadius(3)
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

#Preview {
    MiniBarChart(data: [
        .init(id: "1", label: "Lun", value: 12),
        .init(id: "2", label: "Mar", value: 15),
        .init(id: "3", label: "Mer", value: 9),
        .init(id: "4", label: "Jeu", value: 18),
        .init(id: "5", label: "Ven", value: 11),
        .init(id: "6", label: "Sam", value: 8),
        .init(id: "7", label: "Dim", value: 14),
    ])
    .frame(height: 60)
    .padding()
}
