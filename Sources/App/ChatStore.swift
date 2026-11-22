import Foundation

@MainActor
final class ChatStore: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var rubPerStar: Double = 2.0
    @Published var giftsSent: Int = 0

    private let chatsKey = "litgram.chats.v1"
    private let rateKey = "litgram.rub_per_star.v1"
    private let giftsKey = "litgram.gifts_sent.v1"

    init() {
        load()
    }

    private func load() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: chatsKey),
           let decoded = try? JSONDecoder().decode([Chat].self, from: data) {
            chats = decoded
        } else {
            chats = Self.seed
        }
        if defaults.object(forKey: rateKey) != nil {
            rubPerStar = defaults.double(forKey: rateKey)
        }
        if defaults.object(forKey: giftsKey) != nil {
            giftsSent = defaults.integer(forKey: giftsKey)
        }
    }

    func save() {
        let defaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(chats) {
            defaults.set(data, forKey: chatsKey)
        }
        defaults.set(rubPerStar, forKey: rateKey)
        defaults.set(giftsSent, forKey: giftsKey)
    }

    func send(_ text: String, in chatID: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard let index = chats.firstIndex(where: { $0.id == chatID }) else { return }
        chats[index].messages.append(Message(text: trimmed, outgoing: true))
        chats[index].unread = 0
        save()
    }

    func sendGift(_ gift: NftGift, to chatID: String) {
        guard let index = chats.firstIndex(where: { $0.id == chatID }) else { return }
        chats[index].messages.append(Message(text: "🎁 Подарок: \(gift.title) · \(gift.stars) ⭐", outgoing: true))
        giftsSent += 1
        save()
    }

    func markRead(_ chatID: String) {
        guard let index = chats.firstIndex(where: { $0.id == chatID }) else { return }
        chats[index].unread = 0
        save()
    }

    func rub(_ stars: Int) -> String {
        let value = Double(stars) * rubPerStar
        return String(format: "%.0f ₽", value)
    }

    static let seed: [Chat] = [
        Chat(id: "c1", name: "Анна", emoji: "👩🏻", messages: [
            Message(text: "Привет! Как дела?", outgoing: false),
            Message(text: "Отлично, спасибо! Смотри, какие подарки появились", outgoing: true)
        ], unread: 2),
        Chat(id: "c2", name: "Максим", emoji: "🧑🏽", messages: [
            Message(text: "Отправил тебе NFT-медведя", outgoing: false)
        ], unread: 0),
        Chat(id: "c3", name: "Команда Litgram", emoji: "✨", messages: [
            Message(text: "Добро пожаловать в Litgram — свой мессенджер с NFT-подарками", outgoing: false)
        ], unread: 1),
        Chat(id: "c4", name: "Мама", emoji: "🌷", messages: [
            Message(text: "Позвони, когда будешь свободен", outgoing: false)
        ], unread: 0)
    ]

    static let contacts: [Contact] = [
        Contact(id: "p1", name: "Анна", status: "в сети", emoji: "👩🏻"),
        Contact(id: "p2", name: "Максим", status: "был(а) недавно", emoji: "🧑🏽"),
        Contact(id: "p3", name: "Ирина", status: "в сети", emoji: "👩🏼‍🦰"),
        Contact(id: "p4", name: "Дима", status: "был(а) 2 часа назад", emoji: "🧔🏻"),
        Contact(id: "p5", name: "Команда Litgram", status: "бот", emoji: "✨")
    ]
}
