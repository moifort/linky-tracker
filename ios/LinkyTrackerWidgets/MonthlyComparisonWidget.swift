import Charts
import SwiftUI
import WidgetKit

struct MonthlyComparisonWidget: Widget {
    let kind = "MonthlyComparisonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LinkyTrackerTimelineProvider()) { entry in
            MonthlyComparisonView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Comparaison mensuelle")
        .description("Comparaison avec le mois précédent")
        .supportedFamilies([.systemLarge])
    }
}

struct MonthlyComparisonView: View {
    let entry: LinkyTrackerEntry

    var body: some View {
        if let data = entry.data {
            VStack(alignment: .leading, spacing: 12) {
                Text("Comparaison mensuelle")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Chart(data.weekData) { day in
                    BarMark(
                        x: .value("Jour", day.date, unit: .day),
                        y: .value("kWh", day.kwh)
                    )
                    .foregroundStyle(.blue.gradient)
                    .cornerRadius(2)
                }
                .chartXAxis(.hidden)
                .frame(height: 120)

                Divider()

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ce mois")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.0f", data.currentMonthTotalKwh))
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("kWh")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Mois précédent")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(String(format: "%.0f", data.previousMonthTotalKwh))
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("kWh")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: data.monthEvolutionPercent > 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption2)
                        Text(String(format: "%+.1f%%", data.monthEvolutionPercent))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(data.monthEvolutionPercent > 0 ? .red : .green)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Coût estimé")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 1) {
                            Text(String(format: "%.0f", data.estimatedMonthlyCostEur))
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("€")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        } else {
            VStack {
                Image(systemName: "bolt.slash")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("Chargement...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview(as: .systemLarge) {
    MonthlyComparisonWidget()
} timeline: {
    LinkyTrackerEntry(date: .now, data: .preview)
}
