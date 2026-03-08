import SwiftUI

struct DashboardPage: View {
    @State private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let error = viewModel.errorMessage {
                        ContentUnavailableView(
                            "Erreur",
                            systemImage: "exclamationmark.triangle",
                            description: Text(error)
                        )
                    } else if let dashboard = viewModel.dashboard {
                        DashboardSummaryCard(
                            totalKwh: dashboard.totalKwh,
                            averageDailyKwh: dashboard.averageDailyKwh,
                            estimatedCostEur: dashboard.estimatedCostEur,
                            evolutionPercent: dashboard.previousMonthEvolutionPercent,
                            daysWithData: dashboard.daysWithData
                        )

                        if !viewModel.dailyConsumption.isEmpty {
                            DailyConsumptionChart(
                                data: viewModel.dailyConsumption.map {
                                    .init(id: $0.id, date: $0.date, kwh: $0.kwh)
                                }
                            )
                        }

                        if let distribution = viewModel.hcHpDistribution {
                            HcHpRingChart(
                                hcPercent: distribution.hcPercent,
                                hpPercent: distribution.hpPercent,
                                hcKwh: distribution.totalHcKwh,
                                hpKwh: distribution.totalHpKwh
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .refreshable { await viewModel.load() }
            .task { await viewModel.load() }
        }
    }
}
