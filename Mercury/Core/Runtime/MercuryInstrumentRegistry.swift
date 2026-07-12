import Foundation

final class MercuryInstrumentRegistry {
    static let shared = MercuryInstrumentRegistry()

    private(set) var instruments: [String: any MercuryInstrument] = [:]

    private init() {}

    func register(_ instrument: any MercuryInstrument) {
        instruments[instrument.id] = instrument
    }

    func availableCapabilities() -> [String] {
        instruments.values.flatMap { $0.capabilities }
    }

    func find(capability: String) -> (any MercuryInstrument)? {
        instruments.values.first { $0.capabilities.contains(capability) }
    }
}
