import Charts
import SwiftUI
import WidgetKit

struct WeekOverviewWidget: Widget {
    let kind = "WeekOverviewWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LinkyTrackerTimelineProvider()) { entry in
            WeekOverviewView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Semaine")
        .description("Aperçu des 7 derniers jours et coût estimé")
        .supportedFamilies([.systemMedium])
    }
}

struct WeekOverviewView: View {
    let entry: LinkyTrackerEntry

    var body: some View {
        if let data = entry.data {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("7 derniers jours")
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
                    .chartYAxis(.hidden)
                }

                VStack(alignment: .trailing, spacing: 8) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Coût estimé")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 1) {
                            Text(String(format: "%.0f", data.estimatedMonthlyCostEur))
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("€")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Ce mois")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 1) {
                            Text(String(format: "%.0f", data.currentMonthTotalKwh))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("kWh")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(width: 90)
            }
        } else {
            Text("Chargement...")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview(as: .systemMedium) {
    WeekOverviewWidget()
} timeline: {
    LinkyTrackerEntry(date: .now, data: .preview)
}
