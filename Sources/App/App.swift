import SwiftUI

@main
struct LitgramMessengerApp: App {
    @StateObject private var store = ChatStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if store.didShowWelcome {
                    TabView {
                        CustomFunctionsView()
                            .tabItem { Label("Функции", systemImage: "sparkles.rectangle.stack.fill") }
                            .badge("NEW")
                        ChatsView()
                            .tabItem { Label("Чаты", systemImage: "bubble.left.and.bubble.right.fill") }
                        ContactsView()
                            .tabItem { Label("Контакты", systemImage: "person.2.fill") }
                        NftGiftsView()
                            .tabItem { Label("NFT", systemImage: "sparkles") }
                        ProfileView()
                            .tabItem { Label("Профиль", systemImage: "person.circle.fill") }
                    }
                    .tint(Color.accentColor)
                } else {
                    WelcomeView()
                }
            }
            .environmentObject(store)
        }
    }
}
