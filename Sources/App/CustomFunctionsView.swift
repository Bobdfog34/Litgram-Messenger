import SwiftUI

struct CustomFunctionsView: View {
    @EnvironmentObject var store: ChatStore

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles.rectangle.stack.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Кастомные функции")
                                .font(.headline)
                            Text("Новое в Litgram — первая вкладка настроек")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Вид профиля") {
                    Toggle(isOn: $store.nftBubblesEnabled) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NFT-пузыри вокруг профиля")
                            Text("Закреплённые подарки летают в пузырях вокруг аватара. Выключите, чтобы вернуть классический вид.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onChange(of: store.nftBubblesEnabled) { _, _ in
                        store.save()
                    }

                    if store.nftBubblesEnabled {
                        VStack(spacing: 6) {
                            NftBubbleRing(size: 110)
                            Text("Так выглядит профиль с включёнными пузырями")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }

                Section("Как это работает") {
                    Text("Включите переключатель, чтобы закреплённые NFT-подарки вращались вокруг вашего аватара в профиле. Выключение возвращает прежний вид без анимации.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Функции")
        }
    }
}
