import SwiftUI

struct ObservatoryView: View {
    @EnvironmentObject var state: MercuryState

    var body: some View {
        VStack(spacing: 20) {
            Text("Mercury Observatory")
                .font(.largeTitle.bold())

            Text(state.isKernelReady ? "Kernel Online" : "Kernel Dormant")

            Text("Active Persona: \(state.activePersona.rawValue)")

            Text("Relics: \(state.activeRelics.count)")
        }
        .padding()
    }
}
