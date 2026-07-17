import SwiftUI

struct NotesCaptureView: View {
    @EnvironmentObject var state: MercuryState
    @State private var draft = ""
    @State private var entries: [[String: Any]] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    TextField("Capture a thought…", text: $draft, axis: .vertical)
                        .lineLimit(3...6)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button {
                        saveNote()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                    }
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()

                if entries.isEmpty {
                    ContentUnavailableView(
                        "No notes yet",
                        systemImage: "note.text",
                        description: Text("Everything you capture stays on this device.")
                    )
                } else {
                    List {
                        ForEach(Array(entries.enumerated()), id: \.offset) { _, entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry["content"] as? String ?? "")
                                    .font(.body)
                                if let ts = entry["timestamp"] as? String {
                                    Text(ts)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Notes")
            .onAppear(perform: reload)
        }
    }

    private func reload() {
        entries = MercuryOfflineStore.shared.loadVault()
    }

    private func saveNote() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let entry: [String: Any] = [
            "id": UUID().uuidString,
            "content": text,
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "persona": String(describing: state.activePersona)
        ]

        MercuryOfflineStore.shared.appendVaultEntry(entry)
        state.recordInteraction(type: "noteCaptured", metadata: ["length": text.count])
        draft = ""
        reload()
    }

    private func delete(at offsets: IndexSet) {
        var current = MercuryOfflineStore.shared.loadVault()
        current.remove(atOffsets: offsets)
        MercuryOfflineStore.shared.saveVault(current)
        reload()
    }
}
