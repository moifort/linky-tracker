import Foundation

@MainActor
@Observable
final class DashboardViewModel {
    var dashboard: DashboardData?
    var dailyConsumption: [DailyConsumptionItem] = []
    var hcHpDistribution: HcHpDistribution?
    var isLoading = false
    var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let dashboardResponse: DashboardResponse = try await APIClient.shared.get("/analytics/dashboard")
            dashboard = dashboardResponse.data

            let now = Date()
            let calendar = Calendar.current
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            let dailyResponse: DailyConsumptionResponse = try await APIClient.shared.get(
                "/consumption/daily",
                query: [
                    "start": formatter.string(from: startOfMonth),
                    "end": formatter.string(from: now),
                ]
            )
            dailyConsumption = dailyResponse.data

            let hcHpResponse: HcHpDistributionResponse = try await APIClient.shared.get(
                "/analytics/hc-hp",
                query: [
                    "start": formatter.string(from: startOfMonth),
                    "end": formatter.string(from: now),
                ]
            )
            hcHpDistribution = hcHpResponse.data
        } catch {
            errorMessage = reportError(error)
        }

        isLoading = false
    }
}
