import SwiftUI

@main
struct LitgramMessengerApp: App {
    @StateObject private var store = ChatStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                ChatsView()
                    .tabItem { Label("Чаты", systemImage: "bubble.left.and.bubble.right.fill") }
                ContactsView()
                    .tabItem { Label("Контакты", systemImage: "person.2.fill") }
                NftGiftsView()
                    .tabItem { Label("NFT", systemImage: "sparkles") }
                ProfileView()
                    .tabItem { Label("Профиль", systemImage: "person.circle.fill") }
            }
            .environmentObject(store)
        }
    }
}
