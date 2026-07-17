import Foundation
import SwiftUI

@MainActor
extension MercuryState {
    func restoreFromDisk() {
        let store = MercuryOfflineStore.shared
        let saved = store.activePersona
        if let match = MercuryPersona.allCases.first(where: { String(describing: $0) == saved || $0.rawValue == saved }) {
            self.select(match)
        }
    }

    func syncToDisk() {
        MercuryOfflineStore.shared.activePersona = String(describing: activePersona)
    }

    func recordInteraction(type: String, metadata: [String: Any] = [:]) {
        InteractionMemory.shared.record(
            type: type,
            persona: String(describing: activePersona),
            metadata: metadata
        )
        syncToDisk()
    }
}
