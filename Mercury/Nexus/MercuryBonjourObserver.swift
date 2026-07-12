import Foundation

struct MercuryServiceNode: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let domain: String
}

final class MercuryBonjourObserver {
    static let shared = MercuryBonjourObserver()

    private(set) var discoveredServices: [MercuryServiceNode] = []

    func record(_ service: MercuryServiceNode) {
        discoveredServices.append(service)
    }
}
