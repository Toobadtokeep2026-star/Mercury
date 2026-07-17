import Foundation

@MainActor
final class MercuryOfflineStore {
    static let shared = MercuryOfflineStore()
    private let defaults = UserDefaults.standard
    private let fm = FileManager.default

    private var docs: URL { fm.urls(for: .documentDirectory, in: .userDomainMask)[0] }
    private var vaultURL: URL { docs.appendingPathComponent("mercury_vault.json") }

    var activePersona: String {
        get { defaults.string(forKey: "mercury.activePersona") ?? "soulSworn" }
        set { defaults.set(newValue, forKey: "mercury.activePersona") }
    }

    func saveVault(_ entries: [[String: Any]]) {
        guard let data = try? JSONSerialization.data(withJSONObject: entries, options: [.prettyPrinted]) else { return }
        try? data.write(to: vaultURL, options: [.atomic])
    }

    func loadVault() -> [[String: Any]] {
        guard let data = try? Data(contentsOf: vaultURL),
              let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return [] }
        return json
    }

    func appendVaultEntry(_ entry: [String: Any]) {
        var current = loadVault()
        current.insert(entry, at: 0)
        if current.count > 500 { current = Array(current.prefix(500)) }
        saveVault(current)
    }

    func clearAll() {
        defaults.removeObject(forKey: "mercury.activePersona")
        try? fm.removeItem(at: vaultURL)
    }
}
