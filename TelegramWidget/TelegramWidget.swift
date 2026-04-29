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
        let launchURL = URL(string: "tg://")!

        Group {
            switch family {
            case .accessoryCircular:
                CircularBadge()
            case .accessoryRectangular:
                RectangularBadge()
            case .accessoryInline:
                Label("Telegram", systemImage: "paperplane.fill")
            default:
                CircularBadge()
            }
        }
        .widgetURL(launchURL)
    }
}

private struct CircularBadge: View {
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            Image(systemName: "paperplane.fill")
                .font(.system(size: 22, weight: .bold))
                .rotationEffect(.degrees(-15))
        }
    }
}

private struct RectangularBadge: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 18, weight: .bold))
                .rotationEffect(.degrees(-15))
            Text("Telegram")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
    }
}

struct TelegramWidget: Widget {
    let kind: String = "TelegramWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TelegramProvider()) { entry in
            if #available(iOS 17.0, *) {
                TelegramWidgetEntryView()
                    .containerBackground(.clear, for: .widget)
            } else {
                TelegramWidgetEntryView()
            }
        }
        .configurationDisplayName("Telegram")
        .description("Tap to open Telegram.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}
