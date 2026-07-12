import Foundation

final class MercuryKernel {
    static let shared = MercuryKernel()

    private init() {}

    func boot() {
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
