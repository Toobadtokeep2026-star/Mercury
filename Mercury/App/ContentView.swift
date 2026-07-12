import SwiftUI

struct ContentView: View {
    @State private var persona: MercuryPersona = .soulSworn

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Mercury")
                    .font(.largeTitle.bold())

                Text(persona.title)
                    .font(.title2)

                Text(persona.description)
                    .multilineTextAlignment(.center)
                    .padding()

                Picker("Persona", selection: $persona) {
                    ForEach(MercuryPersona.allCases) { persona in
                        Text(persona.rawValue).tag(persona)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
        }
    }
}
