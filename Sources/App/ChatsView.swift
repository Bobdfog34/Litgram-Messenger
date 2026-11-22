import SwiftUI

struct ChatsView: View {
    @EnvironmentObject var store: ChatStore
    @State private var activeChatID: String?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.chats) { chat in
                    Button {
                        activeChatID = chat.id
                        store.markRead(chat.id)
                    } label: {
                        HStack(spacing: 12) {
                            Text(chat.emoji)
                                .font(.title)
                                .frame(width: 46, height: 46)
                                .background(Color.accentColor.opacity(0.12))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(chat.name).font(.headline).foregroundStyle(.primary)
                                Text(chat.lastMessage?.text ?? "Нет сообщений")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            if chat.unread > 0 {
                                Text("\(chat.unread)")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(.white)
                                    .padding(7)
                                    .background(Color.accentColor)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Чаты")
            .navigationDestination(item: $activeChatID) { chatID in
                ChatDetailView(chatID: chatID)
            }
        }
    }
}

struct ChatDetailView: View {
    @EnvironmentObject var store: ChatStore
    let chatID: String
    @State private var text = ""

    private var chat: Chat? { store.chats.first { $0.id == chatID } }

    var body: some View {
        VStack(spacing: 0) {
            if let chat {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(chat.messages) { message in
                                HStack {
                                    if message.outgoing { Spacer(minLength: 40) }
                                    Text(message.text)
                                        .padding(12)
                                        .background(message.outgoing ? Color.accentColor.opacity(0.18) : Color.secondary.opacity(0.12))
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    if !message.outgoing { Spacer(minLength: 40) }
                                }
                                .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chat.messages.count) { _, _ in
                        if let last = chat.messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
                HStack(spacing: 10) {
                    TextField("Сообщение", text: $text)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        store.send(text, in: chatID)
                        text = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
        }
        .navigationTitle(chat?.name ?? "Чат")
        .navigationBarTitleDisplayMode(.inline)
    }
}
