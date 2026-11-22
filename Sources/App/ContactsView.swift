import SwiftUI

struct ContactsView: View {
    @State private var query = ""

    private var filtered: [Contact] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return q.isEmpty ? ChatStore.contacts : ChatStore.contacts.filter { $0.name.lowercased().contains(q) }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { contact in
                HStack(spacing: 12) {
                    Text(contact.emoji)
                        .font(.title)
                        .frame(width: 46, height: 46)
                        .background(Color.accentColor.opacity(0.12))
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(contact.name).font(.headline)
                        Text(contact.status).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .searchable(text: $query, prompt: "Поиск контактов")
            .navigationTitle("Контакты")
        }
    }
}
