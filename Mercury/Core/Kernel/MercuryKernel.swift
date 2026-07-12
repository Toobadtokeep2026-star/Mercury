import Foundation

final class MercuryKernel {
    static let shared = MercuryKernel()

    private(set) var isBooted = false

    private init() {}

    func boot() {
        guard !isBooted else { return }
        isBooted = true
        MercuryEventBus.shared.publish("kernel.ready", payload: Date())
    }

    func execute(_ intent: MercuryIntent) {
        MercuryEventBus.shared.publish("intent.received", payload: intent)
    }
}

enum MercuryIntent {
    case create
    case automate
    case research
    case execute
    case converse
}
