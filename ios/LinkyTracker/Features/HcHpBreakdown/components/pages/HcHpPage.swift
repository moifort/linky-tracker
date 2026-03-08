import SwiftUI

struct HcHpPage: View {
    @State private var viewModel = HcHpViewModel()

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
                    } else if let distribution = viewModel.distribution {
                        HcHpPieChart(
                            hcKwh: distribution.totalHcKwh,
                            hpKwh: distribution.totalHpKwh,
                            hcPercent: distribution.hcPercent,
                            hpPercent: distribution.hpPercent,
                            hcCostEur: distribution.hcCostEur,
                            hpCostEur: distribution.hpCostEur
                        )

                        HcHpDailyBreakdown(loadCurves: viewModel.loadCurves)
                    }
                }
                .padding()
            }
            .navigationTitle("HC / HP")
            .refreshable { await viewModel.load() }
            .task { await viewModel.load() }
        }
    }
}
