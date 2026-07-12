import Foundation

import SwiftUI

enum MercuryAspect: String, CaseIterable {
    case mercury = "Soul Sworn"
    case forge = "Forge"
    case eternal = "Eternal"
}

struct MercuryPersona {
    let aspect: MercuryAspect
    let purpose: String
}

extension MercuryPersona {
    static let all = [
        MercuryPersona(aspect: .mercury, purpose: "Companion, observer, strategist"),
        MercuryPersona(aspect: .forge, purpose: "Creation, experimentation, invention"),
        MercuryPersona(aspect: .eternal, purpose: "Execution, automation, intent")
    ]
}
