import UIKit

enum LaunchTelegram {
    static let candidateURLs: [URL] = [
        URL(string: "tg://")!,
        URL(string: "tgapp://")!
    ]

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
