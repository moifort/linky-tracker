import SwiftUI

struct MonthlyTrendsPage: View {
    @State private var viewModel = MonthlyTrendsViewModel()

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
                    } else if !viewModel.trends.isEmpty {
                        MonthlyComparisonChart(
                            data: viewModel.trends.suffix(6).map {
                                .init(id: $0.id, month: $0.displayMonth, kwh: $0.totalKwh, costEur: $0.estimatedCostEur)
                            }
                        )

                        MonthlyDetailList(trends: viewModel.trends)
                    }
                }
                .padding()
            }
            .navigationTitle("Tendances")
            .refreshable { await viewModel.load() }
            .task { await viewModel.load() }
        }
    }
}
