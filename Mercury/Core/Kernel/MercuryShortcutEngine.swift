import Foundation

final class MercuryShortcutEngine {
    static let shared = MercuryShortcutEngine()

    private var shortcuts: [String: MercuryIntent] = [:]

    func register(_ name: String, intent: MercuryIntent) {
        shortcuts[name] = intent
    }

    func run(_ name: String) {
        guard let intent = shortcuts[name] else { return }
        MercuryKernel.shared.execute(intent)
    }
}
