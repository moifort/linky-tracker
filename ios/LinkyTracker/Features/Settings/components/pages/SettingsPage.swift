import SwiftUI

struct SettingsPage: View {
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Tarification HC/HP") {
                    HStack {
                        Text("Tarif HP")
                        Spacer()
                        TextField("€/kWh", text: $viewModel.hpRate)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    HStack {
                        Text("Tarif HC")
                        Spacer()
                        TextField("€/kWh", text: $viewModel.hcRate)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    HStack {
                        Text("Début HC")
                        Spacer()
                        TextField("HH:mm", text: $viewModel.hcSlotStart)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    HStack {
                        Text("Fin HC")
                        Spacer()
                        TextField("HH:mm", text: $viewModel.hcSlotEnd)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    HStack {
                        Text("Abonnement/mois")
                        Spacer()
                        TextField("€", text: $viewModel.subscriptionMonthly)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }

                    Button(action: { Task { await viewModel.saveConfig() } }) {
                        if viewModel.isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Sauvegarder")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(viewModel.isSaving)
                }

                Section("Synchronisation") {
                    Button(action: { Task { await viewModel.triggerSync() } }) {
                        if viewModel.isSyncing {
                            HStack {
                                ProgressView()
                                Text("Synchronisation en cours...")
                            }
                        } else {
                            Label("Synchroniser maintenant", systemImage: "arrow.triangle.2.circlepath")
                        }
                    }
                    .disabled(viewModel.isSyncing)

                    ForEach(viewModel.syncStatuses) { status in
                        HStack {
                            Text(status.displayType)
                                .font(.subheadline)
                            Spacer()
                            if let lastDate = status.lastSyncedDate {
                                Text(lastDate)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Jamais")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }

                if let success = viewModel.successMessage {
                    Section {
                        Text(success)
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("Réglages")
            .task { await viewModel.loadConfig() }
        }
    }
}
