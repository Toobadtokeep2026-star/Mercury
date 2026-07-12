import Foundation

final class MercuryRelicRegistry {
    static let shared = MercuryRelicRegistry()

    private(set) var relics: [String: MercuryRelic] = [:]

    private init() {}

    func bind(_ relic: MercuryRelic) {
        relics[relic.name] = relic
    }

    func availableRelics() -> [MercuryRelic] {
        Array(relics.values)
    }

    func capabilities() -> [String] {
        relics.values.flatMap { $0.capabilities }
    }
}
