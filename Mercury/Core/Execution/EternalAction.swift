import Foundation

struct EternalAction: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let requiresApproval: Bool
}

final class EternalEngine {
    static let shared = EternalEngine()

    private(set) var actions: [EternalAction] = []

    func register(_ action: EternalAction) {
        actions.append(action)
    }

    func availableActions() -> [EternalAction] {
        actions
    }
}
