import SwiftUI
import WidgetKit

struct TodayConsumptionWidget: Widget {
    let kind = "TodayConsumptionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LinkyTrackerTimelineProvider()) { entry in
            TodayConsumptionView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Conso du jour")
        .description("Consommation du jour et tendance")
        .supportedFamilies([.systemSmall])
    }
}

struct TodayConsumptionView: View {
    let entry: LinkyTrackerEntry

    var body: some View {
        if let data = entry.data {
            VStack(alignment: .leading, spacing: 8) {
                Text("Aujourd'hui")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let todayKwh = data.todayKwh {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(String(format: "%.1f", todayKwh))
                            .font(.title)
                            .fontWeight(.bold)
                        Text("kWh")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("--")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }

                if let trend = data.trendPercent {
                    HStack(spacing: 2) {
                        Image(systemName: trend > 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption2)
                        Text(String(format: "%+.0f%%", trend))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(trend > 0 ? .red : .green)
                }

                Spacer()

                Text("vs hier")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        } else {
            Text("Chargement...")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview(as: .systemSmall) {
    TodayConsumptionWidget()
} timeline: {
    LinkyTrackerEntry(date: .now, data: .preview)
    LinkyTrackerEntry(date: .now, data: nil)
}
