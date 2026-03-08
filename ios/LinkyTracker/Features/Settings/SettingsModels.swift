import Foundation

struct PricingConfigResponse: Codable, Sendable {
    let status: Int
    let data: PricingConfigData?
}

struct PricingConfigData: Codable, Sendable {
    let id: String
    let tariffType: String
    let hpRate: Double
    let hcRate: Double
    let hcSlots: [HcSlotData]
    let subscriptionMonthlyEur: Double
    let updatedAt: Date
}

struct HcSlotData: Codable, Sendable {
    let start: String
    let end: String
}

struct PricingConfigInput: Codable, Sendable {
    let hpRate: Double
    let hcRate: Double
    let hcSlots: [HcSlotData]
    let subscriptionMonthlyEur: Double
}

struct SyncResponse: Codable, Sendable {
    let status: Int
    let data: SyncResult
}

struct SyncResult: Codable, Sendable {
    let outcome: String
}

struct SyncStatusResponse: Codable, Sendable {
    let status: Int
    let data: [SyncStatusItem]
}

struct SyncStatusItem: Codable, Sendable, Identifiable {
    let type: String
    let lastSyncedDate: String?
    let lastSyncedAt: Date?

    var id: String { type }

    var displayType: String {
        switch type {
        case "daily-consumption": return "Consommation"
        case "load-curve": return "Courbe de charge"
        case "max-power": return "Puissance max"
        default: return type
        }
    }
}
