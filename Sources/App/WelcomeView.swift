import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var store: ChatStore

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accentColor.opacity(0.22), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer(minLength: 20)

                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.14))
                        .frame(width: 148, height: 148)
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 62, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }

                Text("Litgram")
                    .font(.system(size: 44, weight: .bold, design: .rounded))

                Text("Самый быстрый мессенджер с NFT-подарками")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                VStack(alignment: .leading, spacing: 14) {
                    Label("Личные и групповые чаты", systemImage: "bubble.left.and.bubble.right.fill")
                    Label("NFT-подарки в галерее и в профиле", systemImage: "sparkles")
                    Label("Кастомные функции в одном месте", systemImage: "slider.horizontal.3")
                }
                .font(.subheadline)
                .padding(.horizontal, 40)

                Spacer()

                Button {
                    store.didShowWelcome = true
                    store.save()
                } label: {
                    Text("Продолжить")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal, 32)
                .padding(.bottom, 36)
            }
        }
    }
}
