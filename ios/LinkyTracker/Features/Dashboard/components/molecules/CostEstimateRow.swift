import SwiftUI

struct CostEstimateRow: View {
    let label: String
    let costEur: Double
    let trendPercent: Double?

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            EurLabel(costEur)
            if let trendPercent {
                TrendBadge(percent: trendPercent)
            }
        }
    }
}

#Preview {
    List {
        CostEstimateRow(label: "Estimation mensuelle", costEur: 85.50, trendPercent: 12.3)
        CostEstimateRow(label: "Estimation mensuelle", costEur: 72.10, trendPercent: -5.2)
        CostEstimateRow(label: "Estimation mensuelle", costEur: 60.00, trendPercent: nil)
    }
}
