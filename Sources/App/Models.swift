import Foundation

struct Message: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let outgoing: Bool
    let date: Date

    init(id: String = UUID().uuidString, text: String, outgoing: Bool, date: Date = Date()) {
        self.id = id
        self.text = text
        self.outgoing = outgoing
        self.date = date
    }
}

struct Chat: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let emoji: String
    var messages: [Message]
    var unread: Int

    var lastMessage: Message? { messages.last }
}

struct Contact: Identifiable, Hashable {
    let id: String
    let name: String
    let status: String
    let emoji: String
}

struct NftGift: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let stars: Int
    let convertStars: Int
    let upgradeStars: Int
    let modelCount: Int
    let patternCount: Int
    let backdropCount: Int
    let models: [String]
    let thumb: String

    var isUpgradeable: Bool { modelCount > 0 }
}
