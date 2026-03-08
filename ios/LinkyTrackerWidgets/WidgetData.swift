import Foundation

struct WidgetData: Codable, Sendable {
    let todayKwh: Double?
    let yesterdayKwh: Double?
    let trendPercent: Double?
    let weekData: [DayKwh]
    let currentMonthTotalKwh: Double
    let estimatedMonthlyCostEur: Double
    let previousMonthTotalKwh: Double
    let monthEvolutionPercent: Double
    let lastUpdated: Date

    struct DayKwh: Codable, Sendable, Identifiable {
        let id: String
        let date: Date
        let kwh: Double
    }
}

struct WidgetDataResponse: Codable, Sendable {
    let status: Int
    let data: WidgetData
}
