# BiteQuest

BiteQuest is an offline-first micro‑learning app with game‑style XP, streaks, and rapid lessons. It’s designed to keep users engaged without needing a backend.

## Features
- Micro‑lessons with key takeaways
- XP rewards and streaks with local persistence
- Daily goal setting + profile name
- Daily reminders (local notifications)
- Quick quizzes with instant feedback
- Dynamic app icons + quick actions
- Android home screen widgets (XP/Streak + Path)
- Clean, bold UI with light animations

## Local Setup
1. Install Flutter (3.38+ recommended)
2. Install dependencies

```bash
cd micro_learning_app
flutter pub get
```

3. Run the app

```bash
flutter run
```

## Clean Architecture Layout
- `lib/domain`: core models + repository contracts + use cases
- `lib/data`: data sources + repository implementations
- `lib/core`: cross‑cutting services (notifications, theme)
- `lib/presentation`: UI, widgets, and controller

## Reminders (Android)
The app requests `POST_NOTIFICATIONS` on Android 13+ when reminders are enabled.
The reminder time can be changed in the Progress tab.

## Dynamic App Icons
- Android uses activity aliases (`MainActivity.streak`, `MainActivity.xp`, etc.).
- iOS uses alternate icon sets in `Assets.xcassets` configured in `Info.plist`.
Replace the placeholder iOS icon sets (`AppIconStreak`, `AppIconXp`, etc.) with your final art.

## Quick Actions (Long‑Press)
Shortcut items are registered via `quick_actions` and map to tabs:
- Start Lesson
- Take Quiz
- View Progress
- Set Daily Goal
- Reminder Settings

Android icon resources live in `android/app/src/main/res/drawable/ic_shortcut_*.xml`.
For iOS shortcut icons, add template images with the same names to `Runner/Assets.xcassets`.

## Widgets
Android widgets are implemented with `home_widget`:
- XP + streak widget
- Path/timeline widget

For iOS widgets, open the iOS project in Xcode and add a WidgetKit extension,
then set the same App Group ID used in `main.dart`.

## App Icons
This project uses `flutter_launcher_icons`.

Generate launcher icons:

```bash
flutter pub run flutter_launcher_icons
```

Icon sources:
- `micro_learning_app/assets/icons/bitequest_icon.png`
- `micro_learning_app/assets/icons/bitequest_foreground.png`

## Android Release Build (Play Store)
1. Create a keystore

```bash
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias bitequest
```

2. Move the keystore under `micro_learning_app/android/keystore/`.

3. Create `micro_learning_app/android/key.properties` using the template:

`micro_learning_app/android/key.properties.example`

4. Build an Android App Bundle (AAB):

```bash
flutter build appbundle
```

The output will be at:
`micro_learning_app/build/app/outputs/bundle/release/app-release.aab`

## Play Store Release Checklist
- Update version in `micro_learning_app/pubspec.yaml` (both `versionName` and `versionCode`).
- Confirm package id: `com.bitequest.app`.
- Generate app icon and screenshots.
- Prepare store listing: title, short/long description, privacy policy link.
- Upload AAB to the Play Console.
- Complete content rating, data safety, and target audience forms.

## Notes
- The release signing config is wired in `micro_learning_app/android/app/build.gradle.kts` and will use `android/key.properties` if it exists.
- If `key.properties` is missing, the app will still build with debug signing for testing.
