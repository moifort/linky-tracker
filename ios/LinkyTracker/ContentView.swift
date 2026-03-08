import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "house.fill") {
                DashboardPage()
            }

            Tab("Tendances", systemImage: "chart.bar.fill") {
                MonthlyTrendsPage()
            }

            Tab("HC/HP", systemImage: "chart.pie.fill") {
                HcHpPage()
            }

            Tab("Réglages", systemImage: "gearshape.fill") {
                SettingsPage()
            }
        }
    }
}

#Preview {
    ContentView()
}
