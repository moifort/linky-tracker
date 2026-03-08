import Foundation

@MainActor
@Observable
final class SettingsViewModel {
    var hpRate = "0.2516"
    var hcRate = "0.2068"
    var hcSlotStart = "22:00"
    var hcSlotEnd = "06:00"
    var subscriptionMonthly = "12.60"
    var syncStatuses: [SyncStatusItem] = []
    var isSyncing = false
    var isSaving = false
    var isLoading = false
    var errorMessage: String?
    var successMessage: String?

    func loadConfig() async {
        isLoading = true
        do {
            let response: PricingConfigResponse = try await APIClient.shared.get("/pricing/config")
            if let config = response.data {
                hpRate = String(format: "%.4f", config.hpRate)
                hcRate = String(format: "%.4f", config.hcRate)
                if let firstSlot = config.hcSlots.first {
                    hcSlotStart = firstSlot.start
                    hcSlotEnd = firstSlot.end
                }
                subscriptionMonthly = String(format: "%.2f", config.subscriptionMonthlyEur)
            }
            await loadSyncStatus()
        } catch {
            errorMessage = reportError(error)
        }
        isLoading = false
    }

    func saveConfig() async {
        isSaving = true
        errorMessage = nil
        successMessage = nil

        do {
            let input = PricingConfigInput(
                hpRate: Double(hpRate) ?? 0,
                hcRate: Double(hcRate) ?? 0,
                hcSlots: [HcSlotData(start: hcSlotStart, end: hcSlotEnd)],
                subscriptionMonthlyEur: Double(subscriptionMonthly) ?? 0
            )
            let _: PricingConfigResponse = try await APIClient.shared.put("/pricing/config", body: input)
            successMessage = "Configuration sauvegardée"
        } catch {
            errorMessage = reportError(error)
        }

        isSaving = false
    }

    func triggerSync() async {
        isSyncing = true
        errorMessage = nil
        successMessage = nil

        do {
            let _: SyncResponse = try await APIClient.shared.post("/sync", body: EmptyBody())
            successMessage = "Synchronisation terminée"
            await loadSyncStatus()
        } catch {
            errorMessage = reportError(error)
        }

        isSyncing = false
    }

    func loadSyncStatus() async {
        do {
            let response: SyncStatusResponse = try await APIClient.shared.get("/sync/status")
            syncStatuses = response.data
        } catch {
            // Silently fail for status
        }
    }
}

private struct EmptyBody: Codable, Sendable {}
