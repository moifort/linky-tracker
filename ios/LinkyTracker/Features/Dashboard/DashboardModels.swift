import Foundation

struct DashboardResponse: Codable, Sendable {
    let status: Int
    let data: DashboardData
}

struct DashboardData: Codable, Sendable {
    let totalKwh: Double
    let averageDailyKwh: Double
    let estimatedCostEur: Double
    let previousMonthEvolutionPercent: Double?
    let daysWithData: Int
}

struct DailyConsumptionResponse: Codable, Sendable {
    let status: Int
    let data: [DailyConsumptionItem]
}

struct DailyConsumptionItem: Codable, Sendable, Identifiable {
    let id: String
    let date: Date
    let totalWh: Double
    let fetchedAt: Date

    var kwh: Double { totalWh / 1000 }
}

struct HcHpDistributionResponse: Codable, Sendable {
    let status: Int
    let data: HcHpDistribution
}

struct HcHpDistribution: Codable, Sendable {
    let totalHcKwh: Double
    let totalHpKwh: Double
    let hcPercent: Double
    let hpPercent: Double
    let hcCostEur: Double
    let hpCostEur: Double
}
