import SwiftUI

@main
struct TelegramLockWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    guard LaunchTelegram.shouldHandleDeepLink(url) else { return }
                    Task { @MainActor in
                        LaunchTelegram.open()
                    }
                }
        }
    }
}
