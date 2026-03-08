import SwiftUI
import WidgetKit

@main
struct LinkyTrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodayConsumptionWidget()
        WeekOverviewWidget()
        MonthlyComparisonWidget()
    }
}
