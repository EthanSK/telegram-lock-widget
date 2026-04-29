# Telegram Lock Widget

A tiny iOS app whose only job is to put a **single small Telegram tile** on your iPhone that opens Telegram when tapped. Telegram's official iOS app doesn't ship a lock-screen accessory widget, so this fills that gap for personal use.

> Unofficial. Not affiliated with, sponsored by, or endorsed by Telegram. The icon and copy in this app are an independent paper-plane mark, not Telegram's logo.

## What it does

- Adds one lock-screen icon tile (`accessoryCircular`) — the closest iOS allows to a single square on the lock screen.
- Adds the same idea as a single small square Home Screen widget (`systemSmall`) for testing or if you prefer it there.
- Tapping either widget opens this tiny launcher app via `telegramlockwidget://open`, then the launcher immediately opens Telegram via `tg://` / `tgapp://`.
- Includes a small containing app with an "Open Telegram" button — useful as a fallback and to confirm the URL scheme works on your device.

## Requirements

- iOS 16.0 or later (lock-screen widgets were introduced in iOS 16).
- Xcode 15 or later on a Mac.
- An Apple ID (free personal team is fine for sideloading to your own device).
- Telegram for iOS installed on the target device.

## Local install (sideload to your own iPhone)

1. Clone the repo and open `TelegramLockWidget.xcodeproj` in Xcode.
2. Select the `TelegramLockWidget` scheme and a connected iPhone as the run destination.
3. In the project editor, set **Signing & Capabilities → Team** to your personal Apple ID for **both** targets:
   - `TelegramLockWidget` (the app)
   - `TelegramWidgetExtension` (the widget)
4. Change the bundle identifiers if `com.ethansk.TelegramLockWidget` is taken in your account — the widget bundle id must remain a child of the app bundle id (e.g. `com.you.TelegramLockWidget` and `com.you.TelegramLockWidget.TelegramWidget`).
5. Press **Run** (⌘R). Trust the developer profile on the phone if prompted (Settings → General → VPN & Device Management).
6. On the phone, long-press the lock screen → Customize → Lock Screen → tap one small widget slot → pick **Telegram**.
7. Optional: add the **Telegram** small square widget to the Home Screen if you want the literal square tile too.

Free personal-team builds expire after 7 days; rebuild and redeploy from Xcode when that happens.

## How it works

- The widget extension uses WidgetKit with `supportedFamilies` set to `.accessoryCircular` and `.systemSmall` only — no extra rectangular/inline variants.
- Each widget view sets `.widgetURL(URL(string: "telegramlockwidget://open")!)` because WidgetKit is most reliable when it opens the containing app first.
- The containing app handles that deep link and immediately opens Telegram via `tg://` or `tgapp://`.
- The containing app declares `tg` and `tgapp` in `LSApplicationQueriesSchemes` so `UIApplication.canOpenURL(_:)` works correctly.
- If Telegram cannot be opened (not installed), the in-app button shows a small fallback message. Lock-screen taps with no Telegram installed will just land in the launcher app.

## Limitations

- iOS Lock Screen widgets are not literal arbitrary square widgets; this uses the one small lock-screen icon tile Apple allows, plus a literal small square Home Screen widget.
- Lock-screen widgets are tap-only — there is no way for a widget to open another app silently or skip the lock-screen unlock step.
- iOS may require unlocking (Face ID / passcode) before the launch URL is honoured, depending on your "Allow Access When Locked → Control Center / Today View" settings.
- This project does **not** use any private Telegram APIs or assets. The icon is a generic paper-plane glyph generated locally by `scripts/generate_app_icon.py`.

## Project layout

```
TelegramLockWidget.xcodeproj/        # Xcode project (manually authored)
TelegramLockWidget/                  # App target (SwiftUI)
  TelegramLockWidgetApp.swift
  ContentView.swift
  LaunchTelegram.swift
  Info.plist
  Assets.xcassets/
TelegramWidget/                      # Widget extension target
  TelegramWidgetBundle.swift
  TelegramWidget.swift
  Info.plist
  Assets.xcassets/
scripts/generate_app_icon.py         # Stdlib-only PNG generator for the app icon
```

## Regenerating the app icon

```sh
python3 scripts/generate_app_icon.py
```

Writes `TelegramLockWidget/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png`. The asset catalog references that single 1024×1024 image; iOS scales it for all device sizes.

## License

MIT — see [LICENSE](LICENSE).
