import WidgetKit

struct LinkyTrackerEntry: TimelineEntry {
    let date: Date
    let data: WidgetData?
}

struct LinkyTrackerTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> LinkyTrackerEntry {
        LinkyTrackerEntry(date: .now, data: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (LinkyTrackerEntry) -> Void) {
        if context.isPreview {
            completion(LinkyTrackerEntry(date: .now, data: .preview))
            return
        }
        Task { @MainActor in
            let data = try? await WidgetAPIClient.fetchWidgetData()
            completion(LinkyTrackerEntry(date: .now, data: data))
        }
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<LinkyTrackerEntry>) -> Void) {
        Task { @MainActor in
            let data = try? await WidgetAPIClient.fetchWidgetData()
            let entry = LinkyTrackerEntry(date: .now, data: data)

            let calendar = Calendar.current
            var nextRefresh = calendar.date(bySettingHour: 10, minute: 30, second: 0, of: .now)!
            if nextRefresh <= .now {
                nextRefresh = calendar.date(byAdding: .day, value: 1, to: nextRefresh)!
            }

            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
}

extension WidgetData {
    static let preview = WidgetData(
        todayKwh: 8.5,
        yesterdayKwh: 12.3,
        trendPercent: -30.9,
        weekData: (0..<7).map { day in
            DayKwh(
                id: "\(day)",
                date: Calendar.current.date(byAdding: .day, value: -day, to: .now)!,
                kwh: Double.random(in: 5...20)
            )
        },
        currentMonthTotalKwh: 185.3,
        estimatedMonthlyCostEur: 42.50,
        previousMonthTotalKwh: 420.0,
        monthEvolutionPercent: -8.5,
        lastUpdated: .now
    )
}
