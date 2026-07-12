import Foundation

enum MercuryPersona: String, CaseIterable, Identifiable {
    case forge = "Forge"
    case soulSworn = "Soul Sworn"
    case immortal = "Immortal"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .forge: return "The Cosmic Alchemist"
        case .soulSworn: return "The Bound Companion"
        case .immortal: return "The Executor"
        }
    }

    var description: String {
        switch self {
        case .forge:
            return "Creator, inventor, mad scientist, and alchemist. The laboratory of impossible ideas."
        case .soulSworn:
            return "The default companion. Ancient trickster energy, loyal counsel, sharp wit, and honest criticism."
        case .immortal:
            return "Direct action mode. Automation, execution, systems, and results."
        }
    }
}
