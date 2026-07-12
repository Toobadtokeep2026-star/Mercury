import Foundation

protocol MercuryInstrument {
    var id: String { get }
    var name: String { get }
    var capabilities: [String] { get }

    func activate(with input: MercuryInstrumentRequest) async throws -> MercuryInstrumentResult
}

struct MercuryInstrumentRequest {
    let action: String
    let parameters: [String: String]
}

struct MercuryInstrumentResult {
    let success: Bool
    let output: String
}
