import SwiftUI
import WidgetKit

struct TelegramEntry: TimelineEntry {
    let date: Date
}

struct TelegramProvider: TimelineProvider {
    func placeholder(in context: Context) -> TelegramEntry {
        TelegramEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (TelegramEntry) -> Void) {
        completion(TelegramEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TelegramEntry>) -> Void) {
        let entry = TelegramEntry(date: Date())
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct TelegramWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SquareTelegramTile()
            default:
                LockScreenIconTile()
            }
        }
        .widgetURL(URL(string: "telegramlockwidget://open")!)
    }
}

private struct LockScreenIconTile: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(.white.opacity(0.18))
            Image(systemName: "paperplane.fill")
                .font(.system(size: 22, weight: .bold))
                .rotationEffect(.degrees(-15))
        }
    }
}

private struct SquareTelegramTile: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.16, green: 0.59, blue: 0.86),
                    Color(red: 0.09, green: 0.40, blue: 0.71)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 10) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 44, weight: .bold))
                    .rotationEffect(.degrees(-15))
                Text("Telegram")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.white)
        }
    }
}

struct TelegramWidget: Widget {
    let kind: String = "TelegramWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TelegramProvider()) { entry in
            if #available(iOSApplicationExtension 17.0, *) {
                TelegramWidgetEntryView()
                    .containerBackground(.clear, for: .widget)
            } else {
                TelegramWidgetEntryView()
            }
        }
        .configurationDisplayName("Telegram")
        .description("One small tile that opens Telegram.")
        .supportedFamilies([
            .accessoryCircular,
            .systemSmall
        ])
    }
}
