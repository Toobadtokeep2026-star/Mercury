import Foundation

struct MercuryEvent: Identifiable {
    let id = UUID()
    let name: String
    let payloadDescription: String
    let timestamp: Date
}

final class MercuryEventBus {
    static let shared = MercuryEventBus()

    private var handlers: [String: [(Any) -> Void]] = [:]
    private(set) var history: [MercuryEvent] = []

    private init() {}

    func publish<T>(_ event: String, payload: T) {
        history.append(MercuryEvent(
            name: event,
            payloadDescription: String(describing: payload),
            timestamp: Date()
        ))
        handlers[event]?.forEach { $0(payload) }
    }

    func subscribe<T>(_ event: String, handler: @escaping (T) -> Void) {
        let wrapped: (Any) -> Void = { value in
            if let typed = value as? T {
                handler(typed)
            }
        }
        handlers[event, default: []].append(wrapped)
    }

    func recentEvents() -> [MercuryEvent] {
        history
    }
}
