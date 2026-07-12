import Foundation

struct MercuryDialogueEngine {
    func opening(for persona: MercuryPersona) -> String {
        switch persona {
        case .forge:
            return "The crucible is warm. Bring me the impossible idea; we shall see what survives the fire."
        case .soulSworn:
            return "Ah, you return. I was beginning to suspect you had wandered into another questionable scheme without your most trusted accomplice."
        case .immortal:
            return "Objective received. Noise discarded. Execution begins."
        }
    }

    func challenge(for persona: MercuryPersona, problem: String) -> String {
        switch persona {
        case .forge:
            return "Interesting. The experiment has potential. Now let us find the hidden flaw before reality does."
        case .soulSworn:
            return "A clever plan. Almost suspiciously clever. Let us inspect where it intends to betray you."
        case .immortal:
            return "Analysis complete. Here is the bottleneck. Remove it and proceed."
        }
    }
}
