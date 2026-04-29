import SwiftUI

struct ContentView: View {
    @State private var fallbackMessage: String?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.16, green: 0.59, blue: 0.86),
                    Color(red: 0.09, green: 0.40, blue: 0.71)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                PaperPlaneBadge()
                    .frame(width: 140, height: 140)
                    .padding(.top, 40)

                Text("Telegram Lock Widget")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Add the widget to your lock screen, then tap it to jump straight into Telegram.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                Button(action: openTelegramFromButton) {
                    Text("Open Telegram")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.09, green: 0.40, blue: 0.71))
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)

                if let fallbackMessage {
                    Text(fallbackMessage)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Text("Unofficial · Not affiliated with Telegram")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 24)
            }
        }
    }

    private func openTelegramFromButton() {
        LaunchTelegram.open { success in
            fallbackMessage = success
                ? nil
                : "Telegram doesn't seem to be installed on this device."
        }
    }
}

private struct PaperPlaneBadge: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.18))
            Image(systemName: "paperplane.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .rotationEffect(.degrees(-15))
                .padding(28)
        }
    }
}

#Preview {
    ContentView()
}
