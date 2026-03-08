import Foundation

@MainActor
@Observable
final class MonthlyTrendsViewModel {
    var trends: [MonthlyTrendItem] = []
    var isLoading = false
    var errorMessage: String?
    var months = 12

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: MonthlyTrendsResponse = try await APIClient.shared.get(
                "/analytics/monthly-trends",
                query: ["months": "\(months)"]
            )
            trends = response.data
        } catch {
            errorMessage = reportError(error)
        }

        isLoading = false
    }
}
