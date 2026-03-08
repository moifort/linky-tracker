import Foundation

@MainActor
@Observable
final class HcHpViewModel {
    var distribution: HcHpDistribution?
    var loadCurves: [DailyLoadCurve] = []
    var isLoading = false
    var errorMessage: String?
    var periodDays = 7

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let end = Date()
            let start = Calendar.current.date(byAdding: .day, value: -periodDays, to: end)!

            let distResponse: HcHpDistributionResponse = try await APIClient.shared.get(
                "/analytics/hc-hp",
                query: [
                    "start": formatter.string(from: start),
                    "end": formatter.string(from: end),
                ]
            )
            distribution = distResponse.data

            let curveResponse: LoadCurveResponse = try await APIClient.shared.get(
                "/consumption/load-curve",
                query: [
                    "start": formatter.string(from: start),
                    "end": formatter.string(from: end),
                ]
            )
            loadCurves = curveResponse.data
        } catch {
            errorMessage = reportError(error)
        }

        isLoading = false
    }
}
