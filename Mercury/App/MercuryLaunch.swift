import Foundation
import SwiftUI

@main
struct MercuryApp: App {
    @StateObject private var mercury = MercuryState()

    init() {
        MercuryEventBus.shared.publish("mercury.boot.created", payload: "Launch")
    }

    var body: some Scene {
        WindowGroup {
            ObservatoryView()
                .environmentObject(mercury)
                .task {
                    mercury.boot()
                }
        }
    }
}
