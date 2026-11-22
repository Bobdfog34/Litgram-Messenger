import SwiftUI

struct NftGiftsView: View {
    @EnvironmentObject var store: ChatStore
    @State private var query = ""
    @State private var selected: NftGift?
    @State private var showUpgradeableOnly = false

    private let gifts: [NftGift] = NftGiftsView.loadCatalog()

    private var filtered: [NftGift] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return gifts.filter { gift in
            (q.isEmpty || gift.title.lowercased().contains(q)) &&
            (!showUpgradeableOnly || gift.isUpgradeable)
        }
    }

    private static func loadCatalog() -> [NftGift] {
        guard let url = Bundle.main.url(forResource: "nft_catalog", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([NftGift].self, from: data) else {
            return []
        }
        return items
    }

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filtered) { gift in
                        Button { selected = gift } label: {
                            VStack(spacing: 6) {
                                ThumbView(name: gift.thumb)
                                    .frame(height: 110)
                                Text(gift.title)
                                    .font(.subheadline.weight(.semibold))
                                    .lineLimit(1)
                                Text("\(gift.stars) ⭐ · \(store.rub(gift.stars))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                if gift.isUpgradeable {
                                    Text("NFT · \(gift.modelCount) моделей")
                                        .font(.caption2)
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color.secondary.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .searchable(text: $query, prompt: "Поиск подарков")
            .navigationTitle("NFT-подарки")
            .toolbar {
                Button {
                    showUpgradeableOnly.toggle()
                } label: {
                    Image(systemName: showUpgradeableOnly ? "sparkles" : "sparkles.rectangle.stack")
                }
            }
            .sheet(item: $selected) { gift in
                GiftDetailView(gift: gift)
            }
        }
    }
}

struct GiftDetailView: View {
    @EnvironmentObject var store: ChatStore
    @Environment(\.dismiss) private var dismiss
    let gift: NftGift
    @State private var chatID = "c1"
    @State private var sent = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ThumbView(name: gift.thumb)
                        .frame(height: 220)
                        .padding()
                        .background(Color.secondary.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                    Text(gift.title)
                        .font(.title2.weight(.bold))

                    HStack(spacing: 24) {
                        VStack {
                            Text("\(gift.stars) ⭐").font(.headline)
                            Text("цена").font(.caption).foregroundStyle(.secondary)
                        }
                        VStack {
                            Text(store.rub(gift.stars)).font(.headline)
                            Text("по курсу").font(.caption).foregroundStyle(.secondary)
                        }
                        if gift.isUpgradeable {
                            VStack {
                                Text("\(gift.upgradeStars) ⭐").font(.headline)
                                Text("апгрейд").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }

                    if gift.isUpgradeable {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Оригинальная NFT-коллекция").font(.headline)
                            Text("Моделей: \(gift.modelCount) · паттернов: \(gift.patternCount) · фонов: \(gift.backdropCount)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if !gift.models.isEmpty {
                                Text("Примеры: \(gift.models.joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.accentColor.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Picker("Отправить в чат", selection: $chatID) {
                        ForEach(store.chats) { chat in
                            Text(chat.name).tag(chat.id)
                        }
                    }
                    .pickerStyle(.menu)

                    Button {
                        store.sendGift(gift, to: chatID)
                        sent = true
                    } label: {
                        Label("Подарить", systemImage: "gift.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    if sent {
                        Text("Подарок отправлен в чат")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                }
                .padding()
            }
            .navigationTitle("Подарок")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Готово") { dismiss() }
            }
        }
    }
}
