import Foundation

struct MercuryDataObservation {
    let category: String
    let metric: String
    let value: String
    let timestamp: Date
}

final class MercuryDataMonitor {
    static let shared = MercuryDataMonitor()

    private(set) var observations: [MercuryDataObservation] = []

    func observe(_ item: MercuryDataObservation) {
        observations.append(item)
    }

    func recent(_ category: String) -> [MercuryDataObservation] {
        observations.filter { $0.category == category }
    }
}
