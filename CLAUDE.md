# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run              # Run on connected device/emulator
flutter analyze          # Static analysis / lint
flutter test             # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter pub get          # Install / sync dependencies
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

## Stack

- **Language**: Dart / Flutter
- **State**: plain `setState()` — no external state management library
- **Persistence**: `SharedPreferences` only — no database, no backend, no network calls ever
- **Notifications**: `flutter_local_notifications` (on-device, scheduled)
- **Key packages**: `uuid`, `intl`, `flutter_animate`

## Folder structure

```
lib/
  main.dart                     # Entry point — inits StorageService & NotificationService, runs SoulGraceApp
  app.dart                      # MaterialApp root: theme, named routes
  constants/
    app_colors.dart             # All Color values
    app_strings.dart            # Every user-facing string (no hardcoded strings elsewhere)
    app_theme.dart              # ThemeData built from AppColors
  data/
    content.dart                # Hardcoded ScriptureVerse and PrayerContent lists
  models/
    journal_entry.dart          # JournalEntry data class with toJson/fromJson
    prayer.dart                 # Prayer data class with toJson/fromJson
  services/
    storage_service.dart        # Thin SharedPreferences wrapper + StorageKeys constants
    notification_service.dart   # flutter_local_notifications wrapper
  screens/
    home/home_screen.dart
    prayer/prayer_screen.dart
    journal/journal_screen.dart
    settings/settings_screen.dart
  widgets/                      # Reusable UI components (shared across screens)
```

## Design rules

| Rule | Value |
|------|-------|
| Background | `#FAF7F2` — pastel cream (`AppColors.background`) |
| Accent | `#C3B8E8` — muted lavender (`AppColors.accent`) |
| Text | `#3D3535` — soft charcoal (`AppColors.text`) |
| Min touch target | 48 × 48 dp (Flutter Material standard) |

- **No hardcoded strings** — all copy lives in `app_strings.dart`
- **Semantic labels** on every interactive widget (`Semantics`, `tooltip`, or `semanticLabel`)
- **No database, no network** — `StorageService` (SharedPreferences) is the only persistence layer
- All new colors go in `app_colors.dart`; reference via `AppColors.*` everywhere
- New screens get their own subdirectory under `screens/`; shared widgets go in `widgets/`
