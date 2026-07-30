# fluhoowlib

A personal reading companion built with Flutter.

fluhoowlib helps you organize your library, track reading consistency, and keep your book data local and under your control.

## Why fluhoowlib

- Keep your own private book catalog with detailed metadata.
- Track reading habit streaks on a calendar with one tap per day.
- Filter and sort your library to quickly find what matters now.
- Use a clean bilingual app experience (English and German).
- Run fully offline with local SQLite storage.

## Highlights

- Book details: title, author, publication date, finished date, rating, ISBN, notes, and borrowed status.
- Reading habit calendar with current streak and longest streak tracking.
- Theme support (light/dark) and app settings persistence.
- Optional developer mode with tools for mock data and database inspection.

## Developer Guide

### Project Identity

- Repository: fluhoowlib
- Flutter package name: hoowlib
- App display name: Hoowlib

### Requirements

- Flutter SDK >= 3.10.7
- Dart SDK compatible with Flutter 3.10.7+

### Setup

1. Install dependencies:

```zsh
flutter pub get
```

2. Run the app:

```zsh
flutter run
```

### Localization Workflow

1. Add a new key to all ARB files:

```zsh
./add2arb.sh newKeyword
```

2. Generate localization files:

```zsh
flutter gen-l10n
```

### Main Dependencies

- flutter_localizations
- intl
- table_calendar
- sqflite
- path
- url_launcher
- package_info_plus
- provider
- keyboard_safe

See pubspec.yaml for the complete dependency list and versions.

### Project Structure

- lib/ - Main source code
  - db/ - Database helpers and migrations
  - l10n/ - ARB files and generated localizations
  - models/ - Data models
  - pages/ - Feature pages (library, calendar, settings, dev)
  - providers/ - State management with Provider
  - repositories/ - Data repository abstractions
  - theme/ - App theming
  - widgets/ - Reusable UI components

### Current Scope vs Planned Work

Implemented now:

- Rich book metadata including notes and borrowing info.
- Library filter modes: all, borrowed, read, unread.
- Calendar-based day tracking and streaks.

Planned next:

- Reading session details (pages, duration, per-session notes).
- Expanded analytics and trends.
- Additional quality improvements and tests.

## Contributing

Contributions are welcome.

- Check CHANGELOG.md for completed work.
- Check ROADMAP.md for upcoming plans.

---

## Availability

Hoowlib is currently available on:

- iOS via the App Store
- Android via direct APK download: https://deckelmouck.de/hoowlib/

For questions or suggestions, open an issue or contact me.