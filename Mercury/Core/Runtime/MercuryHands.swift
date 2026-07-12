import Foundation

struct MercuryHand {
    let name: String
    let purpose: String
    let capabilities: [String]
}

final class MercuryHands {
    static let shared = MercuryHands()

    let availableHands: [MercuryHand] = [
        MercuryHand(
            name: "Shortcut Hand",
            purpose: "Advanced iOS automation and workflows",
            capabilities: ["App Intents", "Shortcuts", "Automation chains"]
        ),
        MercuryHand(
            name: "Siri Hand",
            purpose: "Native iOS assistant collaboration",
            capabilities: ["Voice triggers", "Siri integration", "Intent routing"]
        ),
        MercuryHand(
            name: "Creation Hand",
            purpose: "Laboratory and Forge operations",
            capabilities: ["Code", "Design", "Brainstorming", "Prototyping"]
        ),
        MercuryHand(
            name: "Execution Hand",
            purpose: "Immortal task completion systems",
            capabilities: ["Planning", "Automation", "Project execution"]
        )
    ]
}
