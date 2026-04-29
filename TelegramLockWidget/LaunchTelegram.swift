import Foundation
import UIKit

enum LaunchTelegram {
    static let widgetLaunchURL = URL(string: "telegramlockwidget://open")!

    static let candidateURLs: [URL] = [
        URL(string: "tg://")!,
        URL(string: "tgapp://")!
    ]

    static func shouldHandleDeepLink(_ url: URL) -> Bool {
        url.scheme == "telegramlockwidget" && url.host == "open"
    }

    @MainActor
    static func open(completion: ((Bool) -> Void)? = nil) {
        for url in candidateURLs where UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                completion?(success)
            }
            return
        }
        completion?(false)
    }
}
