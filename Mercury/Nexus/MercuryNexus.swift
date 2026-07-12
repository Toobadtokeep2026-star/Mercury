import Foundation

struct MercuryDiagnosticSnapshot {
    let timestamp: Date
    let networkState: String
    let bluetoothState: String
    let observations: [String]
}

final class MercuryNexus {
    static let shared = MercuryNexus()

    private(set) var snapshots: [MercuryDiagnosticSnapshot] = []

    func record(_ snapshot: MercuryDiagnosticSnapshot) {
        snapshots.append(snapshot)
    }

    func latest() -> MercuryDiagnosticSnapshot? {
        snapshots.last
    }
}
