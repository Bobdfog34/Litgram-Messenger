import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var store: ChatStore

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 10) {
                        ZStack {
                            if store.nftBubblesEnabled {
                                NftBubbleRing(size: 132)
                            }
                            Text("🙂")
                                .font(.system(size: 46))
                                .frame(width: 64, height: 64)
                                .background(Color.accentColor.opacity(0.12))
                                .clipShape(Circle())
                        }
                        .frame(width: 142, height: 142)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Вы").font(.title3.weight(.semibold))
                            Text("Аккаунт Litgram").font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                Section("Статистика") {
                    LabeledContent("Сообщений отправлено", value: "\(store.chats.reduce(0) { $0 + $1.messages.filter { $0.outgoing }.count })")
                    LabeledContent("NFT-подарков отправлено", value: "\(store.giftsSent)")
                    LabeledContent("Чатов", value: "\(store.chats.count)")
                }
                Section("Курс для оценки NFT") {
                    Stepper(value: $store.rubPerStar, in: 0.5...10, step: 0.5) {
                        Text("1 ⭐ = \(String(format: "%.1f", store.rubPerStar)) ₽")
                    }
                    .onChange(of: store.rubPerStar) { _, _ in store.save() }
                    Text("Пример: 50 ⭐ = \(store.rub(50))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("О приложении") {
                    Text("Litgram — собственный мессенджер. NFT-подарки в галерее взяты из оригинальной коллекции подарков; код приложения не основан на исходниках сторонних мессенджеров.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Профиль")
        }
    }
}
