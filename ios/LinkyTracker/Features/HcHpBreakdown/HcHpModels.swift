import Foundation

struct LoadCurveResponse: Codable, Sendable {
    let status: Int
    let data: [DailyLoadCurve]
}

struct DailyLoadCurve: Codable, Sendable, Identifiable {
    let id: String
    let date: Date
    let readings: [LoadCurveReading]
    let fetchedAt: Date
}

struct LoadCurveReading: Codable, Sendable {
    let slot: String
    let averageW: Double
}
