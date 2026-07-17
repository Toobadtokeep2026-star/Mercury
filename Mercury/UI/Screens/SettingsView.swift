import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var state: MercuryState
    @State private var showResetConfirm = false

    var body: some View {
        NavigationStack {
            List {
                Section("Persona") {
                    Picker("Active Persona", selection: Binding(
                        get: { state.activePersona },
                        set: { state.select($0); state.recordInteraction(type: "personaSwitch") }
                    )) {
                        ForEach(MercuryPersona.allCases) { persona in
                            Text(persona.title).tag(persona)
                        }
                    }
                }
                Section("About") {
                    LabeledContent("Version", value: "0.2 Free")
                    LabeledContent("Interactions", value: "\(InteractionMemory.shared.totalCount)")
                }
                Section {
                    Button("Reset Local Data", role: .destructive) { showResetConfirm = true }
                } footer: {
                    Text("Clears local preferences and notes. App remains installed.")
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Reset all local data?", isPresented: $showResetConfirm) {
                Button("Reset", role: .destructive) {
                    MercuryOfflineStore.shared.clearAll()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}
