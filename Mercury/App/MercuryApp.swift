import SwiftUI

@main
struct MercuryApp: App {
    @StateObject private var state = MercuryState()

    var body: some Scene {
        WindowGroup {
            ObservatoryView()
                .environmentObject(state)
        }
    }
}

final class MercuryState: ObservableObject {
    @Published var activeAspect = "Mercury"
    @Published var status = "Awakening"

    func boot() {
        status = "Online"
    }
}
