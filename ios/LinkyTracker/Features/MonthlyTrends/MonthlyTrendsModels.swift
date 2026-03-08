import Foundation

struct MonthlyTrendsResponse: Codable, Sendable {
    let status: Int
    let data: [MonthlyTrendItem]
}

struct MonthlyTrendItem: Codable, Sendable, Identifiable {
    let month: String
    let totalKwh: Double
    let averageDailyKwh: Double
    let estimatedCostEur: Double
    let evolutionPercent: Double?

    var id: String { month }

    var displayMonth: String {
        let parts = month.split(separator: "-")
        guard parts.count == 2, let monthNum = Int(parts[1]) else { return month }
        let months = ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"]
        let yearShort = String(parts[0].suffix(2))
        return "\(months[monthNum - 1]) \(yearShort)"
    }
}
