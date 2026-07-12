import Foundation

struct MercuryRelic {
    let name: String
    let purpose: String
    let capabilities: [String]
}

final class MercuryRelics {
    static let shared = MercuryRelics()

    let availableRelics: [MercuryRelic] = [
        MercuryRelic(
            name: "Shortcut Relic",
            purpose: "Advanced iOS automation and workflows",
            capabilities: ["App Intents", "Shortcuts", "Automation chains"]
        ),
        MercuryRelic(
            name: "Siri Relic",
            purpose: "Native iOS assistant collaboration",
            capabilities: ["Voice triggers", "Siri integration", "Intent routing"]
        ),
        MercuryRelic(
            name: "Creation Relic",
            purpose: "Laboratory and Forge operations",
            capabilities: ["Code", "Design", "Brainstorming", "Prototyping"]
        ),
        MercuryRelic(
            name: "Execution Relic",
            purpose: "Immortal task completion systems",
            capabilities: ["Planning", "Automation", "Project execution"]
        )
    ]
}
