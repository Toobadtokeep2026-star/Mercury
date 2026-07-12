import Foundation

struct EternalProtocol {
    let name: String
    let purpose: String
    let category: String
    let requiresConfirmation: Bool
}

final class EternalProtocolLibrary {
    static let shared = EternalProtocolLibrary()

    let protocols: [EternalProtocol] = [
        EternalProtocol(
            name: "Ritual Chains",
            purpose: "Combine multiple approved actions into workflows",
            category: "Automation",
            requiresConfirmation: true
        ),
        EternalProtocol(
            name: "Observatory Watch",
            purpose: "Monitor personal device and connectivity state",
            category: "Diagnostics",
            requiresConfirmation: false
        ),
        EternalProtocol(
            name: "Chaos Laboratory",
            purpose: "Experiment with personal productivity workflows",
            category: "Creation",
            requiresConfirmation: true
        ),
        EternalProtocol(
            name: "Mischief Mode",
            purpose: "Playful customization, surprises, and creative routines",
            category: "Personality",
            requiresConfirmation: true
        )
    ]
}
