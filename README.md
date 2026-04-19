# fluhoowlib

**fluhoowlib** is a Flutter library and app for managing books and tracking reading habits. It provides features for cataloging books, recording reading progress, and analyzing reading statistics. The project is designed with localization support and extensibility in mind.

## Features

- **Book Management**: Add, edit, and organize books with properties such as title, author, publication year, read year, number of pages, notes, and borrowed status.
- **Reading Habit Tracking**: Track daily reading activity, including pages read, reading time, and notes. Visualize streaks and progress using a calendar view.
- **Localization**: Supports multiple languages (currently English and German). Easily add new keywords and generate localization files.
- **Modern Flutter Architecture**: Uses Provider for state management, sqflite for local storage, and modular page structure.

## Getting Started

### Requirements
- Flutter SDK >= 3.10.7
- Dart >= 3.0

### Setup
1. Install dependencies:
	 ```zsh
	 flutter pub get
	 ```
2. Run the app:
	 ```zsh
	 flutter run
	 ```

### Localization
- Add a new keyword to both ARB files:
	```zsh
	./add2arb.sh newKeyword
	```
- Generate localization files:
	```zsh
	flutter gen-l10n
	```

## Main Dependencies

- flutter_localizations
- intl
- table_calendar
- sqflite
- path
- url_launcher
- package_info_plus
- provider

See `pubspec.yaml` for the full list.

## Roadmap

### Books
- Add more properties to book:
	- Publish year
	- Read year
	- Number of pages
	- Notes
	- Borrowed

### Reading Habit Tracking
- Add more values:
	- Amount of pages
	- Time for reading
	- Notes
- Selection of a book:
	- Unread or as actually reading

## Project Structure

- `lib/` — Main source code
	- `db/` — Database helpers
	- `l10n/` — Localization files
	- `models/` — Data models
	- `pages/` — UI pages (library, calendar, settings, etc.)
	- `providers/` — State management
	- `repositories/` — Data repositories
	- `theme/` — App theming
	- `widgets/` — Reusable widgets

## Contributing

Contributions are welcome! Please see the ROADMAP for planned features and improvements.

---
This project is not yet published to pub.dev. For questions or suggestions, open an issue or contact the maintainer.