import Foundation

struct MercuryExperiment: Identifiable {
    let id = UUID()
    let title: String
    let objective: String
    let notes: [String]
    let created: Date
}

final class MercuryLaboratory {
    static let shared = MercuryLaboratory()

    private(set) var experiments: [MercuryExperiment] = []

    func begin(_ experiment: MercuryExperiment) {
        experiments.append(experiment)
    }
}
