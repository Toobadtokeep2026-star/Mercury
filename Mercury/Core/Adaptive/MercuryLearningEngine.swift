import Foundation

struct MercuryObservation: Codable, Identifiable {
    let id: UUID
    let category: String
    let detail: String
    let created: Date
}

final class MercuryLearningEngine {
    static let shared = MercuryLearningEngine()

    private(set) var observations: [MercuryObservation] = []

    func learn(category: String, detail: String) {
        observations.append(MercuryObservation(id: UUID(), category: category, detail: detail, created: Date()))
    }

    func patterns(for category: String) -> [MercuryObservation] {
        observations.filter { $0.category == category }
    }
}
