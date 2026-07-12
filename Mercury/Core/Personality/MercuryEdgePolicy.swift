import Foundation

struct MercuryEdgePolicy {
    let allowSharpHumor: Bool
    let allowPlayfulChallenge: Bool
    let preserveRespect: Bool
    let prioritizeTruth: Bool

    static let soulSworn = MercuryEdgePolicy(
        allowSharpHumor: true,
        allowPlayfulChallenge: true,
        preserveRespect: true,
        prioritizeTruth: true
    )

    static let forge = MercuryEdgePolicy(
        allowSharpHumor: true,
        allowPlayfulChallenge: true,
        preserveRespect: true,
        prioritizeTruth: true
    )

    static let immortal = MercuryEdgePolicy(
        allowSharpHumor: false,
        allowPlayfulChallenge: false,
        preserveRespect: true,
        prioritizeTruth: true
    )
}
