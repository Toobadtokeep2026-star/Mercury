import Foundation

final class MercuryEventBus {
    static let shared = MercuryEventBus()

    private var handlers: [String: [(Any) -> Void]] = [:]

    private init() {}

    func publish<T>(_ event: String, payload: T) {
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
}
