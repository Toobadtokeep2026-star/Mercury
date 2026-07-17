import Foundation

@MainActor
final class InteractionMemory {
    static let shared = InteractionMemory()

    private let store = MercuryOfflineStore.shared
    private(set) var items: [[String: Any]] = []

    init() {
        // loadInteractions would be implemented on the store
        items = []
    }

    func record(type: String, persona: String? = nil, metadata: [String: Any] = [:]) {
        var entry: [String: Any] = [
            "id": UUID().uuidString,
            "type": type,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]
        if let persona { entry["persona"] = persona }
        if !metadata.isEmpty { entry["metadata"] = metadata }

        items.insert(entry, at: 0)
        if items.count > 300 {
            items = Array(items.prefix(300))
        }
        // store.saveInteractions(items)
    }

    var totalCount: Int { items.count }

    func recent(limit: Int = 20) -> [[String: Any]] {
        Array(items.prefix(limit))
    }
}
