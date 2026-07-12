import Foundation

struct MercuryMemoryEntry: Identifiable, Codable {
    let id: UUID
    let title: String
    let content: String
    let created: Date
}

final class MercuryMemoryVault {
    static let shared = MercuryMemoryVault()

    private(set) var entries: [MercuryMemoryEntry] = []

    func store(_ entry: MercuryMemoryEntry) {
        entries.append(entry)
    }

    func search(_ text: String) -> [MercuryMemoryEntry] {
        entries.filter { $0.content.localizedCaseInsensitiveContains(text) }
    }
}
